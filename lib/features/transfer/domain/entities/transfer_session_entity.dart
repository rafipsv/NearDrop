import 'package:equatable/equatable.dart';

import '../../../discovery/domain/entities/device_entity.dart';
import 'file_item_entity.dart';
import 'transfer_session_status.dart';

class TransferSessionEntity extends Equatable {
  const TransferSessionEntity({
    required this.sessionId,
    required this.senderDevice,
    required this.receiverDevice,
    required this.files,
    required this.status,
    required this.createdAt,
  });

  final String sessionId;
  final DeviceEntity senderDevice;
  final DeviceEntity receiverDevice;
  final List<FileItemEntity> files;
  final TransferSessionStatus status;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    sessionId,
    senderDevice,
    receiverDevice,
    files,
    status,
    createdAt,
  ];
}
