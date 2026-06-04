import 'package:equatable/equatable.dart';

import '../../domain/entities/device_entity.dart';

abstract class DiscoveryEvent extends Equatable {
  const DiscoveryEvent();

  @override
  List<Object?> get props => [];
}

class StartDiscovery extends DiscoveryEvent {
  const StartDiscovery();
}

class StopDiscovery extends DiscoveryEvent {
  const StopDiscovery();
}

class DeviceFound extends DiscoveryEvent {
  const DeviceFound(this.device);

  final DeviceEntity device;

  @override
  List<Object?> get props => [device];
}

class DeviceLost extends DiscoveryEvent {
  const DeviceLost(this.deviceId);

  final String deviceId;

  @override
  List<Object?> get props => [deviceId];
}

class RefreshDiscovery extends DiscoveryEvent {
  const RefreshDiscovery();
}

class SelectDevice extends DiscoveryEvent {
  const SelectDevice(this.device);

  final DeviceEntity device;

  @override
  List<Object?> get props => [device];
}
