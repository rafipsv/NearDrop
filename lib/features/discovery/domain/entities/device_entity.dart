import 'package:equatable/equatable.dart';

import 'device_platform.dart';
import 'device_status.dart';

class DeviceEntity extends Equatable {
  const DeviceEntity({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.port,
    required this.platform,
    required this.status,
    required this.lastSeen,
  });

  final String id;
  final String name;
  final String ipAddress;
  final int port;
  final DevicePlatform platform;
  final DeviceStatus status;
  final DateTime lastSeen;

  @override
  List<Object?> get props => [
    id,
    name,
    ipAddress,
    port,
    platform,
    status,
    lastSeen,
  ];
}
