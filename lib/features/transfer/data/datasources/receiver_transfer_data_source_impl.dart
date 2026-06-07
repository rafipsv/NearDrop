import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../../discovery/domain/entities/device_entity.dart';
import '../../../discovery/domain/entities/device_platform.dart';
import '../../../discovery/domain/entities/device_status.dart';
import '../../domain/entities/file_item_entity.dart';
import '../../domain/entities/transfer_download_update.dart';
import '../../domain/entities/transfer_progress_entity.dart';
import '../../domain/entities/transfer_progress_status.dart';
import '../../domain/entities/transfer_session_entity.dart';
import '../../domain/entities/transfer_session_status.dart';
import '../../domain/value_objects/qr_transfer_payload.dart';
import '../../domain/value_objects/receiver_transfer_exception.dart';
import 'receiver_transfer_data_source.dart';

class ReceiverTransferDataSourceImpl implements ReceiverTransferDataSource {
  const ReceiverTransferDataSourceImpl({
    HttpClient? httpClient,
    Future<Directory> Function()? storageDirectoryProvider,
  }) : _httpClient = httpClient,
       _storageDirectoryProvider = storageDirectoryProvider;

  final HttpClient? _httpClient;
  final Future<Directory> Function()? _storageDirectoryProvider;

  @override
  Stream<TransferDownloadUpdate> downloadFromQrPayload(
    String rawPayload,
  ) async* {
    final payload = QrTransferPayload.parse(rawPayload);
    final client = _httpClient ?? HttpClient();
    client.connectionTimeout = const Duration(seconds: 8);

    try {
      final session = await _fetchSessionMetadata(client, payload);
      final totalBytes = session.files.fold<int>(
        0,
        (total, file) => total + file.size,
      );
      var downloadedBytes = 0;

      yield TransferDownloadUpdate(
        session: session,
        progress: _progress(
          session: session,
          fileId: session.files.isEmpty ? '' : session.files.first.id,
          downloadedBytes: 0,
          totalBytes: totalBytes,
          status: TransferProgressStatus.pending,
        ),
      );

      if (session.files.isEmpty) {
        throw const ReceiverTransferException(
          'No files found in this session.',
        );
      }

      final saveDirectory = await _receiveDirectory();
      final stopwatch = Stopwatch()..start();

      for (final file in session.files) {
        final request = await client.getUrl(Uri.parse(file.downloadUrl));
        final response = await request.close().timeout(
          const Duration(seconds: 20),
        );

        if (response.statusCode != HttpStatus.ok) {
          throw ReceiverTransferException(
            'Could not download ${file.name}. Sender returned ${response.statusCode}.',
          );
        }

        final targetFile = await _uniqueFile(saveDirectory, file.name);
        final sink = targetFile.openWrite();

        try {
          await for (final chunk in response) {
            downloadedBytes += chunk.length;
            sink.add(chunk);

            yield TransferDownloadUpdate(
              session: session,
              progress: _progress(
                session: session,
                fileId: file.id,
                downloadedBytes: downloadedBytes,
                totalBytes: totalBytes,
                elapsed: stopwatch.elapsed,
                status: TransferProgressStatus.running,
              ),
            );
          }
        } finally {
          await sink.close();
        }
      }

      yield TransferDownloadUpdate(
        session: session,
        progress: _progress(
          session: session,
          fileId: session.files.last.id,
          downloadedBytes: totalBytes,
          totalBytes: totalBytes,
          elapsed: stopwatch.elapsed,
          status: TransferProgressStatus.success,
        ),
        isComplete: true,
      );
    } on QrTransferPayloadException {
      rethrow;
    } on ReceiverTransferException {
      rethrow;
    } on TimeoutException {
      throw const ReceiverTransferException(
        'Could not reach sender. Make sure both devices are on the same Wi-Fi.',
      );
    } catch (_) {
      throw const ReceiverTransferException(
        'Could not receive files from this QR code.',
      );
    } finally {
      if (_httpClient == null) {
        client.close(force: true);
      }
    }
  }

  Future<TransferSessionEntity> _fetchSessionMetadata(
    HttpClient client,
    QrTransferPayload payload,
  ) async {
    final metadataUri = Uri.parse(payload.metadataUrl);
    final response = await (await client.getUrl(
      metadataUri,
    )).close().timeout(const Duration(seconds: 12));

    if (response.statusCode != HttpStatus.ok) {
      throw ReceiverTransferException(
        'Could not fetch session metadata. Sender returned ${response.statusCode}.',
      );
    }

    final body = await response.transform(utf8.decoder).join();
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const ReceiverTransferException('Metadata response is invalid.');
    }

    final sessionId = _stringField(decoded, 'sessionId');
    if (sessionId != payload.sessionId) {
      throw const ReceiverTransferException(
        'Scanned session does not match sender metadata.',
      );
    }

    final filesJson = decoded['files'];
    if (filesJson is! List) {
      throw const ReceiverTransferException('Metadata does not include files.');
    }

    final files = filesJson
        .whereType<Map<String, dynamic>>()
        .map(_fileFromJson)
        .toList(growable: false);

    if (files.length != filesJson.length) {
      throw const ReceiverTransferException(
        'Metadata contains invalid file data.',
      );
    }

    return TransferSessionEntity(
      sessionId: sessionId,
      senderDevice: DeviceEntity(
        id: 'sender-${payload.ipAddress}-${payload.port}',
        name: payload.deviceName,
        ipAddress: payload.ipAddress,
        port: payload.port,
        platform: DevicePlatform.unknown,
        status: DeviceStatus.connected,
        lastSeen: DateTime.now(),
      ),
      receiverDevice: DeviceEntity(
        id: 'receiver-local',
        name: Platform.localHostname,
        ipAddress: '',
        port: 0,
        platform: _currentPlatform(),
        status: DeviceStatus.connected,
        lastSeen: DateTime.now(),
      ),
      files: files,
      status: TransferSessionStatus.inProgress,
      createdAt: DateTime.now(),
    );
  }

  FileItemEntity _fileFromJson(Map<String, dynamic> json) {
    final id = _stringField(json, 'id');
    final name = _stringField(json, 'name');
    final mimeType = _stringField(json, 'mimeType');
    final downloadUrl = _stringField(json, 'downloadUrl');
    final sizeValue = json['size'];
    final size = sizeValue is int
        ? sizeValue
        : int.tryParse(sizeValue?.toString() ?? '') ?? -1;
    final uri = Uri.tryParse(downloadUrl);

    if (id.isEmpty ||
        name.isEmpty ||
        mimeType.isEmpty ||
        size < 0 ||
        uri == null ||
        uri.scheme != 'http' ||
        uri.host.isEmpty) {
      throw const ReceiverTransferException('A file in metadata is invalid.');
    }

    return FileItemEntity(
      id: id,
      name: name,
      path: '',
      size: size,
      mimeType: mimeType,
      downloadUrl: downloadUrl,
    );
  }

  TransferProgressEntity _progress({
    required TransferSessionEntity session,
    required String fileId,
    required int downloadedBytes,
    required int totalBytes,
    Duration elapsed = Duration.zero,
    required TransferProgressStatus status,
  }) {
    final percentage = totalBytes == 0
        ? (status == TransferProgressStatus.success ? 1.0 : 0.0)
        : (downloadedBytes / totalBytes).clamp(0.0, 1.0);
    final elapsedSeconds = elapsed.inMilliseconds / 1000;
    final speed = elapsedSeconds <= 0 ? 0.0 : downloadedBytes / elapsedSeconds;
    final remainingBytes = totalBytes - downloadedBytes;
    final remainingSeconds = speed <= 0
        ? null
        : (remainingBytes / speed).ceil().clamp(0, 1 << 31);

    return TransferProgressEntity(
      sessionId: session.sessionId,
      fileId: fileId,
      transferredBytes: downloadedBytes,
      totalBytes: totalBytes,
      percentage: percentage,
      speedBytesPerSecond: speed,
      estimatedRemainingSeconds: remainingSeconds,
      status: status,
    );
  }

  Future<Directory> _receiveDirectory() async {
    final root = _storageDirectoryProvider == null
        ? await getApplicationDocumentsDirectory()
        : await _storageDirectoryProvider();
    final directory = Directory('${root.path}/NearDrop');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  Future<File> _uniqueFile(Directory directory, String rawName) async {
    final name = _safeFileName(rawName);
    final dotIndex = name.lastIndexOf('.');
    final base = dotIndex <= 0 ? name : name.substring(0, dotIndex);
    final extension = dotIndex <= 0 ? '' : name.substring(dotIndex);

    var candidate = File('${directory.path}/$name');
    var index = 1;
    while (await candidate.exists()) {
      candidate = File('${directory.path}/$base ($index)$extension');
      index += 1;
    }
    return candidate;
  }

  String _safeFileName(String fileName) {
    final cleaned = fileName
        .replaceAll(RegExp(r'[\\/:*?"<>|\r\n]'), '_')
        .trim();
    if (cleaned.isEmpty || cleaned == '.' || cleaned == '..') {
      return 'download';
    }
    return cleaned;
  }

  String _stringField(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String) return value.trim();
    throw ReceiverTransferException('Metadata is missing $key.');
  }

  DevicePlatform _currentPlatform() {
    if (Platform.isAndroid) return DevicePlatform.android;
    if (Platform.isIOS) return DevicePlatform.ios;
    return DevicePlatform.unknown;
  }
}
