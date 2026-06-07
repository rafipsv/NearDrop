import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../../../discovery/domain/entities/device_entity.dart';
import '../../../discovery/domain/entities/device_platform.dart';
import '../../../discovery/domain/entities/device_status.dart';
import '../../domain/entities/file_item_entity.dart';
import '../../domain/entities/transfer_session_entity.dart';
import '../../domain/entities/transfer_session_status.dart';
import 'local_sender_server_data_source.dart';

class LocalSenderServerDataSourceImpl implements LocalSenderServerDataSource {
  HttpServer? _server;
  TransferSessionEntity? _session;
  Map<String, FileItemEntity> _filesById = const {};

  @override
  Future<TransferSessionEntity> start(List<FileItemEntity> files) async {
    if (files.isEmpty) {
      throw const FileDropServerException('Select at least one file to share.');
    }

    await stop();

    final sourceFiles = await _validateFiles(files);

    final sessionId = _createSessionId();
    HttpServer? server;

    try {
      final localIp = await _findLocalIpAddress();
      server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      _server = server;

      final baseUrl = 'http://$localIp:${server.port}';
      final shareableFiles = sourceFiles.indexed
          .map((entry) {
            final servedId = 'file-${entry.$1 + 1}-${_createSessionId()}';
            return entry.$2.copyWith(
              id: servedId,
              downloadUrl:
                  '$baseUrl/files/$sessionId/${Uri.encodeComponent(servedId)}',
            );
          })
          .toList(growable: false);

      _filesById = {for (final file in shareableFiles) file.id: file};
      _session = TransferSessionEntity(
        sessionId: sessionId,
        senderDevice: DeviceEntity(
          id: 'sender-$localIp-${server.port}',
          name: Platform.localHostname,
          ipAddress: localIp,
          port: server.port,
          platform: _currentPlatform(),
          status: DeviceStatus.available,
          lastSeen: DateTime.now(),
        ),
        receiverDevice: DeviceEntity(
          id: 'receiver-pending',
          name: 'Waiting receiver',
          ipAddress: '',
          port: 0,
          platform: DevicePlatform.unknown,
          status: DeviceStatus.unavailable,
          lastSeen: DateTime.now(),
        ),
        files: shareableFiles,
        status: TransferSessionStatus.ready,
        createdAt: DateTime.now(),
      );

      _listen(server);
      return _session!;
    } catch (_) {
      await server?.close(force: true);
      _server = null;
      _session = null;
      _filesById = const {};
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    final server = _server;
    _server = null;
    _session = null;
    _filesById = const {};
    await server?.close(force: true);
  }

  void _listen(HttpServer server) {
    server.listen(
      (request) async {
        try {
          await _handleRequest(request);
        } catch (_) {
          request.response
            ..statusCode = HttpStatus.internalServerError
            ..headers.contentType = ContentType.json
            ..write(jsonEncode({'error': 'Server error'}));
          await request.response.close();
        }
      },
      onError: (_) {},
      cancelOnError: false,
    );
  }

  Future<void> _handleRequest(HttpRequest request) async {
    _setCommonHeaders(request.response);

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      return;
    }

    if (request.method != 'GET' && request.method != 'HEAD') {
      await _writeJson(request, {
        'error': 'Method not allowed',
      }, statusCode: HttpStatus.methodNotAllowed);
      return;
    }

    final segments = request.uri.pathSegments;

    if (segments.length == 1 && segments.first == 'health') {
      await _writeJson(request, {'status': 'ok'});
      return;
    }

    if (segments.length == 2 && segments.first == 'session') {
      await _writeSessionMetadata(request, segments[1]);
      return;
    }

    if (segments.length == 3 && segments.first == 'files') {
      await _writeFile(request, sessionId: segments[1], fileId: segments[2]);
      return;
    }

    await _writeJson(request, {
      'error': 'Not found',
    }, statusCode: HttpStatus.notFound);
  }

  Future<void> _writeSessionMetadata(
    HttpRequest request,
    String sessionId,
  ) async {
    final session = _session;
    if (session == null || session.sessionId != sessionId) {
      await _writeJson(request, {
        'error': 'Session not found',
      }, statusCode: HttpStatus.notFound);
      return;
    }

    await _writeJson(request, {
      'sessionId': session.sessionId,
      'deviceName': session.senderDevice.name,
      'ipAddress': session.senderDevice.ipAddress,
      'port': session.senderDevice.port,
      'files': session.files.map(_fileToJson).toList(growable: false),
    });
  }

  Future<void> _writeFile(
    HttpRequest request, {
    required String sessionId,
    required String fileId,
  }) async {
    final session = _session;
    final file = _filesById[fileId];
    if (session == null || session.sessionId != sessionId || file == null) {
      await _writeJson(request, {
        'error': 'File not found',
      }, statusCode: HttpStatus.notFound);
      return;
    }

    final diskFile = File(file.path);
    if (!await diskFile.exists()) {
      await _writeJson(request, {
        'error': 'Selected file is no longer available',
      }, statusCode: HttpStatus.notFound);
      return;
    }

    final length = await diskFile.length();

    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = _safeContentType(file.mimeType)
      ..headers.set(HttpHeaders.contentLengthHeader, length)
      ..headers.set('content-disposition', _contentDisposition(file.name));

    if (request.method == 'GET') {
      await request.response.addStream(diskFile.openRead());
    }
    await request.response.close();
  }

  Future<void> _writeJson(
    HttpRequest request,
    Map<String, Object?> body, {
    int statusCode = HttpStatus.ok,
  }) async {
    request.response
      ..statusCode = statusCode
      ..headers.contentType = ContentType.json
      ..headers.set(HttpHeaders.cacheControlHeader, 'no-store');
    if (request.method == 'GET') {
      request.response.write(jsonEncode(body));
    }
    await request.response.close();
  }

  Map<String, Object?> _fileToJson(FileItemEntity file) {
    return {
      'id': file.id,
      'name': file.name,
      'size': file.size,
      'mimeType': file.mimeType,
      'downloadUrl': file.downloadUrl,
    };
  }

  Future<String> _findLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );

    final candidates = <InternetAddress>[];
    for (final interface in interfaces) {
      for (final address in interface.addresses) {
        if (_isUsableAddress(address.address)) {
          candidates.add(address);
        }
      }
    }

    if (candidates.isEmpty) return InternetAddress.loopbackIPv4.address;
    return candidates
        .firstWhere(
          (address) => _isPrivateLanAddress(address.address),
          orElse: () => candidates.first,
        )
        .address;
  }

  String _createSessionId() {
    final random = Random.secure();
    final values = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '');
  }

  DevicePlatform _currentPlatform() {
    if (Platform.isAndroid) return DevicePlatform.android;
    if (Platform.isIOS) return DevicePlatform.ios;
    return DevicePlatform.unknown;
  }

  Future<List<FileItemEntity>> _validateFiles(
    List<FileItemEntity> files,
  ) async {
    final validFiles = <FileItemEntity>[];
    for (final file in files) {
      if (file.path.isEmpty) {
        throw const FileDropServerException(
          'A selected file has no local path.',
        );
      }

      final diskFile = File(file.path);
      final stat = await diskFile.stat();
      if (stat.type != FileSystemEntityType.file) {
        throw FileDropServerException('${file.name} is not available anymore.');
      }

      validFiles.add(file.copyWith(size: stat.size));
    }
    return validFiles;
  }

  void _setCommonHeaders(HttpResponse response) {
    response.headers
      ..set(HttpHeaders.accessControlAllowOriginHeader, '*')
      ..set(HttpHeaders.accessControlAllowMethodsHeader, 'GET, HEAD, OPTIONS')
      ..set(HttpHeaders.accessControlAllowHeadersHeader, 'content-type')
      ..set('x-content-type-options', 'nosniff');
  }

  ContentType _safeContentType(String mimeType) {
    try {
      return ContentType.parse(mimeType);
    } catch (_) {
      return ContentType.binary;
    }
  }

  String _contentDisposition(String fileName) {
    final fallbackName = fileName
        .replaceAll(RegExp(r'[\r\n"\\]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
    final safeName = fallbackName.isEmpty ? 'download' : fallbackName;
    return 'attachment; filename="$safeName"; filename*=UTF-8\'\'${Uri.encodeComponent(safeName)}';
  }

  bool _isUsableAddress(String address) {
    return address.isNotEmpty &&
        !address.startsWith('127.') &&
        !address.startsWith('169.254.') &&
        address != '0.0.0.0';
  }

  bool _isPrivateLanAddress(String address) {
    if (address.startsWith('10.') || address.startsWith('192.168.')) {
      return true;
    }

    final parts = address.split('.');
    if (parts.length != 4) return false;
    final secondOctet = int.tryParse(parts[1]);
    return parts.first == '172' &&
        secondOctet != null &&
        secondOctet >= 16 &&
        secondOctet <= 31;
  }
}

class FileDropServerException implements Exception {
  const FileDropServerException(this.message);

  final String message;

  @override
  String toString() => message;
}
