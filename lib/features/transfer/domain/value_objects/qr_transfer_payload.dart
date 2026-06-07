import 'dart:convert';

class QrTransferPayload {
  const QrTransferPayload({
    required this.sessionId,
    required this.deviceName,
    required this.ipAddress,
    required this.port,
    required this.metadataUrl,
  });

  static const app = 'NearDrop';
  static const version = 1;

  final String sessionId;
  final String deviceName;
  final String ipAddress;
  final int port;
  final String metadataUrl;

  String encode() {
    return jsonEncode({
      'app': app,
      'version': version,
      'sessionId': sessionId,
      'deviceName': deviceName,
      'ipAddress': ipAddress,
      'port': port,
      'metadataUrl': metadataUrl,
    });
  }

  static QrTransferPayload parse(String rawValue) {
    try {
      final decoded = jsonDecode(rawValue.trim());
      if (decoded is! Map<String, dynamic>) {
        throw const QrTransferPayloadException('QR data is not a session.');
      }

      if (decoded['app'] != app || decoded['version'] != version) {
        throw const QrTransferPayloadException('QR code is not for NearDrop.');
      }

      final sessionId = _stringField(decoded, 'sessionId');
      final deviceName = _stringField(decoded, 'deviceName');
      final ipAddress = _stringField(decoded, 'ipAddress');
      final metadataUrl = _stringField(decoded, 'metadataUrl');
      final port = _intField(decoded, 'port');
      final uri = Uri.tryParse(metadataUrl);

      if (sessionId.isEmpty || deviceName.isEmpty || ipAddress.isEmpty) {
        throw const QrTransferPayloadException(
          'QR code is missing session data.',
        );
      }

      if (port <= 0 || port > 65535) {
        throw const QrTransferPayloadException('QR code has an invalid port.');
      }

      if (uri == null ||
          uri.scheme != 'http' ||
          uri.host.isEmpty ||
          uri.pathSegments.length != 2 ||
          uri.pathSegments.first != 'session') {
        throw const QrTransferPayloadException(
          'QR code has an invalid metadata link.',
        );
      }

      if (uri.pathSegments[1] != sessionId) {
        throw const QrTransferPayloadException(
          'QR code session does not match its metadata link.',
        );
      }

      return QrTransferPayload(
        sessionId: sessionId,
        deviceName: deviceName,
        ipAddress: ipAddress,
        port: port,
        metadataUrl: metadataUrl,
      );
    } on QrTransferPayloadException {
      rethrow;
    } catch (_) {
      throw const QrTransferPayloadException('QR data is invalid.');
    }
  }

  static String _stringField(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String) return value.trim();
    throw QrTransferPayloadException('QR code is missing $key.');
  }

  static int _intField(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? -1;
    throw QrTransferPayloadException('QR code is missing $key.');
  }
}

class QrTransferPayloadException implements Exception {
  const QrTransferPayloadException(this.message);

  final String message;

  @override
  String toString() => message;
}
