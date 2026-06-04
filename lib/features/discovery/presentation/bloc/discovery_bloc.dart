import 'package:flutter_bloc/flutter_bloc.dart';

import 'discovery_event.dart';
import 'discovery_state.dart';

class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  DiscoveryBloc() : super(const DiscoveryInitial()) {
    on<StartDiscovery>(_onStartDiscovery);
    on<StopDiscovery>(_onStopDiscovery);
    on<RefreshDiscovery>(_onRefreshDiscovery);
    on<DeviceFound>(_onDeviceFound);
    on<DeviceLost>(_onDeviceLost);
    on<SelectDevice>(_onSelectDevice);
  }

  void _onStartDiscovery(StartDiscovery event, Emitter<DiscoveryState> emit) {
    emit(DiscoveryScanning(devices: state.devices));
  }

  void _onStopDiscovery(StopDiscovery event, Emitter<DiscoveryState> emit) {
    emit(
      state.devices.isEmpty
          ? const DiscoveryEmpty()
          : DiscoveryLoaded(devices: state.devices),
    );
  }

  void _onRefreshDiscovery(
    RefreshDiscovery event,
    Emitter<DiscoveryState> emit,
  ) {
    emit(const DiscoveryScanning());
  }

  void _onDeviceFound(DeviceFound event, Emitter<DiscoveryState> emit) {
    final devices = [
      for (final device in state.devices)
        if (device.id != event.device.id) device,
      event.device,
    ];
    emit(
      DiscoveryLoaded(devices: devices, selectedDevice: state.selectedDevice),
    );
  }

  void _onDeviceLost(DeviceLost event, Emitter<DiscoveryState> emit) {
    final devices = state.devices
        .where((device) => device.id != event.deviceId)
        .toList(growable: false);
    emit(
      devices.isEmpty
          ? const DiscoveryEmpty()
          : DiscoveryLoaded(devices: devices),
    );
  }

  void _onSelectDevice(SelectDevice event, Emitter<DiscoveryState> emit) {
    emit(DiscoveryLoaded(devices: state.devices, selectedDevice: event.device));
  }
}
