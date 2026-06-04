import 'package:equatable/equatable.dart';

import '../../domain/entities/device_entity.dart';

abstract class DiscoveryState extends Equatable {
  const DiscoveryState({this.devices = const [], this.selectedDevice});

  final List<DeviceEntity> devices;
  final DeviceEntity? selectedDevice;

  @override
  List<Object?> get props => [devices, selectedDevice];
}

class DiscoveryInitial extends DiscoveryState {
  const DiscoveryInitial();
}

class DiscoveryScanning extends DiscoveryState {
  const DiscoveryScanning({super.devices, super.selectedDevice});
}

class DiscoveryLoaded extends DiscoveryState {
  const DiscoveryLoaded({required super.devices, super.selectedDevice});
}

class DiscoveryEmpty extends DiscoveryState {
  const DiscoveryEmpty();
}

class DiscoveryError extends DiscoveryState {
  const DiscoveryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
