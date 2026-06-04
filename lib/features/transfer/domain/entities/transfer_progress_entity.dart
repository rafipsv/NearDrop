import 'package:equatable/equatable.dart';

import 'transfer_progress_status.dart';

class TransferProgressEntity extends Equatable {
  const TransferProgressEntity({
    required this.sessionId,
    required this.fileId,
    required this.transferredBytes,
    required this.totalBytes,
    required this.percentage,
    required this.speedBytesPerSecond,
    required this.estimatedRemainingSeconds,
    required this.status,
  });

  final String sessionId;
  final String fileId;
  final int transferredBytes;
  final int totalBytes;
  final double percentage;
  final double speedBytesPerSecond;
  final int? estimatedRemainingSeconds;
  final TransferProgressStatus status;

  @override
  List<Object?> get props => [
    sessionId,
    fileId,
    transferredBytes,
    totalBytes,
    percentage,
    speedBytesPerSecond,
    estimatedRemainingSeconds,
    status,
  ];
}
