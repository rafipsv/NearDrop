import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:neardrop/features/transfer/data/datasources/local_sender_server_data_source_impl.dart';
import 'package:neardrop/features/transfer/data/datasources/receiver_transfer_data_source_impl.dart';
import 'package:neardrop/features/transfer/domain/entities/file_item_entity.dart';
import 'package:neardrop/features/transfer/domain/entities/transfer_progress_status.dart';
import 'package:neardrop/features/transfer/domain/value_objects/qr_transfer_payload.dart';

void main() {
  test('downloads files from a scanned QR payload with progress', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'neardrop_receiver_test',
    );
    final senderFile = File('${tempDir.path}/hello.txt');
    await senderFile.writeAsString('hello receiver');

    final sender = LocalSenderServerDataSourceImpl();
    final session = await sender.start([
      FileItemEntity(
        id: 'source-file',
        name: 'hello.txt',
        path: senderFile.path,
        size: await senderFile.length(),
        mimeType: 'text/plain',
        downloadUrl: '',
      ),
    ]);

    final receiverRoot = Directory('${tempDir.path}/receiver');
    final receiver = ReceiverTransferDataSourceImpl(
      storageDirectoryProvider: () async => receiverRoot,
    );
    final payload = QrTransferPayload(
      sessionId: session.sessionId,
      deviceName: session.senderDevice.name,
      ipAddress: session.senderDevice.ipAddress,
      port: session.senderDevice.port,
      metadataUrl:
          'http://${session.senderDevice.ipAddress}:${session.senderDevice.port}/session/${session.sessionId}',
    );

    try {
      final updates = await receiver
          .downloadFromQrPayload(payload.encode())
          .toList();
      final savedFile = File('${receiverRoot.path}/NearDrop/hello.txt');

      expect(updates, isNotEmpty);
      expect(updates.last.isComplete, isTrue);
      expect(updates.last.progress.status, TransferProgressStatus.success);
      expect(updates.last.progress.percentage, 1.0);
      expect(await savedFile.readAsString(), 'hello receiver');
    } finally {
      await sender.stop();
      await tempDir.delete(recursive: true);
    }
  });

  test('keeps existing files by saving a unique received filename', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'neardrop_receiver_test',
    );
    final senderFile = File('${tempDir.path}/hello.txt');
    await senderFile.writeAsString('new file');

    final receiverRoot = Directory('${tempDir.path}/receiver');
    final existingDirectory = Directory('${receiverRoot.path}/NearDrop');
    await existingDirectory.create(recursive: true);
    await File('${existingDirectory.path}/hello.txt').writeAsString('old file');

    final sender = LocalSenderServerDataSourceImpl();
    final session = await sender.start([
      FileItemEntity(
        id: 'source-file',
        name: 'hello.txt',
        path: senderFile.path,
        size: await senderFile.length(),
        mimeType: 'text/plain',
        downloadUrl: '',
      ),
    ]);

    final receiver = ReceiverTransferDataSourceImpl(
      storageDirectoryProvider: () async => receiverRoot,
    );
    final payload = QrTransferPayload(
      sessionId: session.sessionId,
      deviceName: session.senderDevice.name,
      ipAddress: session.senderDevice.ipAddress,
      port: session.senderDevice.port,
      metadataUrl:
          'http://${session.senderDevice.ipAddress}:${session.senderDevice.port}/session/${session.sessionId}',
    );

    try {
      await receiver.downloadFromQrPayload(payload.encode()).drain<void>();

      expect(
        await File('${existingDirectory.path}/hello.txt').readAsString(),
        'old file',
      );
      expect(
        await File('${existingDirectory.path}/hello (1).txt').readAsString(),
        'new file',
      );
    } finally {
      await sender.stop();
      await tempDir.delete(recursive: true);
    }
  });
}
