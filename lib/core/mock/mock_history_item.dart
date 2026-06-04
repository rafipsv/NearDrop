class MockHistoryItem {
  const MockHistoryItem({
    required this.fileName,
    required this.fileSize,
    required this.deviceName,
    required this.direction,
    required this.timeLabel,
    required this.status,
    required this.success,
  });

  final String fileName;
  final String fileSize;
  final String deviceName;
  final String direction;
  final String timeLabel;
  final String status;
  final bool success;
}
