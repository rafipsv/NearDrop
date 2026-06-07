import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:neardrop/features/transfer/data/datasources/local_sender_server_data_source_impl.dart';
import 'package:neardrop/features/transfer/domain/entities/file_item_entity.dart';

void main() {
  test('serves metadata and selected file from local sender server', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'neardrop_server_test',
    );
    final sourceFile = File('${tempDir.path}/hello.txt');
    await sourceFile.writeAsString('hello local sharing');

    final dataSource = LocalSenderServerDataSourceImpl();
    final session = await dataSource.start([
      FileItemEntity(
        id: 'hello-file',
        name: 'hello.txt',
        path: sourceFile.path,
        size: await sourceFile.length(),
        mimeType: 'text/plain',
        downloadUrl: '',
      ),
    ]);

    final client = HttpClient();
    try {
      final metadataUri = Uri.parse(
        'http://${session.senderDevice.ipAddress}:${session.senderDevice.port}/session/${session.sessionId}',
      );
      final metadataResponse = await (await client.getUrl(metadataUri)).close();
      final metadataBody = await metadataResponse
          .transform(utf8.decoder)
          .join();
      final metadata = jsonDecode(metadataBody) as Map<String, dynamic>;

      expect(metadataResponse.statusCode, HttpStatus.ok);
      expect(metadata['sessionId'], session.sessionId);
      expect(metadata['files'], isA<List<dynamic>>());
      final metadataFile =
          (metadata['files'] as List<dynamic>).single as Map<String, dynamic>;
      expect(metadataFile['name'], 'hello.txt');
      expect(metadataFile['id'], startsWith('file-1-'));
      expect(metadataFile['id'], isNot(contains(sourceFile.path)));
      expect(metadataBody, isNot(contains(sourceFile.path)));

      final fileResponse = await (await client.getUrl(
        Uri.parse(session.files.single.downloadUrl),
      )).close();
      final fileBody = await fileResponse.transform(utf8.decoder).join();

      expect(fileResponse.statusCode, HttpStatus.ok);
      expect(fileBody, 'hello local sharing');

      final headResponse = await (await client.openUrl(
        'HEAD',
        Uri.parse(session.files.single.downloadUrl),
      )).close();
      expect(headResponse.statusCode, HttpStatus.ok);
      expect(headResponse.headers.contentLength, sourceFile.lengthSync());
    } finally {
      client.close(force: true);
      await dataSource.stop();
      await tempDir.delete(recursive: true);
    }
  });

  test('rejects missing selected files before opening a server', () async {
    final dataSource = LocalSenderServerDataSourceImpl();

    expect(
      () => dataSource.start([
        const FileItemEntity(
          id: 'missing-file',
          name: 'missing.txt',
          path: '/tmp/neardrop_missing_file.txt',
          size: 10,
          mimeType: 'text/plain',
          downloadUrl: '',
        ),
      ]),
      throwsA(isA<FileDropServerException>()),
    );
  });

  test('does not expose unselected file ids', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'neardrop_server_test',
    );
    final sourceFile = File('${tempDir.path}/selected.txt');
    await sourceFile.writeAsString('selected');

    final dataSource = LocalSenderServerDataSourceImpl();
    final session = await dataSource.start([
      FileItemEntity(
        id: 'selected-file',
        name: 'selected.txt',
        path: sourceFile.path,
        size: await sourceFile.length(),
        mimeType: 'text/plain',
        downloadUrl: '',
      ),
    ]);

    final client = HttpClient();
    try {
      final unselectedUrl =
          'http://${session.senderDevice.ipAddress}:${session.senderDevice.port}/files/${session.sessionId}/unselected-file';
      final response = await (await client.getUrl(
        Uri.parse(unselectedUrl),
      )).close();

      expect(response.statusCode, HttpStatus.notFound);
    } finally {
      client.close(force: true);
      await dataSource.stop();
      await tempDir.delete(recursive: true);
    }
  });
}
