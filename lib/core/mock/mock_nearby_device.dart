import '../../features/discovery/domain/entities/device_platform.dart';
import '../../features/discovery/domain/entities/device_status.dart';

class MockNearbyDevice {
  const MockNearbyDevice({
    required this.id,
    required this.name,
    required this.platform,
    required this.status,
    required this.angle,
    required this.orbitFactor,
    required this.colorValue,
  });

  final String id;
  final String name;
  final DevicePlatform platform;
  final DeviceStatus status;
  final double angle;
  final double orbitFactor;
  final int colorValue;
}
