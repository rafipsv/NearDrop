import 'package:flutter_test/flutter_test.dart';
import 'package:neardrop/features/transfer/domain/value_objects/qr_transfer_payload.dart';

void main() {
  test('encodes and parses a valid NearDrop QR payload', () {
    const payload = QrTransferPayload(
      sessionId: 'abc-123',
      deviceName: 'Sender Phone',
      ipAddress: '192.168.1.12',
      port: 8080,
      metadataUrl: 'http://192.168.1.12:8080/session/abc-123',
    );

    final parsed = QrTransferPayload.parse(payload.encode());

    expect(parsed.sessionId, payload.sessionId);
    expect(parsed.deviceName, payload.deviceName);
    expect(parsed.ipAddress, payload.ipAddress);
    expect(parsed.port, payload.port);
    expect(parsed.metadataUrl, payload.metadataUrl);
  });

  test('rejects QR payload from another app', () {
    expect(
      () => QrTransferPayload.parse(
        '{"app":"Other","version":1,"sessionId":"abc","deviceName":"Sender","ipAddress":"192.168.1.12","port":8080,"metadataUrl":"http://192.168.1.12:8080/session/abc"}',
      ),
      throwsA(isA<QrTransferPayloadException>()),
    );
  });

  test('rejects QR payload with mismatched metadata session', () {
    expect(
      () => QrTransferPayload.parse(
        '{"app":"NearDrop","version":1,"sessionId":"abc","deviceName":"Sender","ipAddress":"192.168.1.12","port":8080,"metadataUrl":"http://192.168.1.12:8080/session/other"}',
      ),
      throwsA(isA<QrTransferPayloadException>()),
    );
  });
}
