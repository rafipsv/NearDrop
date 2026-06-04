import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/mock/mock_nearby_device.dart';
import '../../../../core/widgets/app_logo.dart';
import 'device_action_sheet.dart';
import 'device_bubble.dart';
import 'radar_rings.dart';

class DiscoveryScanArea extends StatefulWidget {
  const DiscoveryScanArea({super.key});

  @override
  State<DiscoveryScanArea> createState() => _DiscoveryScanAreaState();
}

class _DiscoveryScanAreaState extends State<DiscoveryScanArea>
    with TickerProviderStateMixin {
  late final AnimationController _sweepController;
  late final AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 96),
    )..repeat();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.w),
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedBuilder(
            animation: Listenable.merge([_sweepController, _orbitController]),
            builder: (context, child) {
              final size = 420.w;
              final sweepAngle = _sweepController.value * math.pi * 2;
              return Stack(
                alignment: Alignment.center,
                children: [
                  RadarRings(sweepAngle: sweepAngle),
                  for (final indexedDevice in MockData.nearbyDevices.indexed)
                    Transform.translate(
                      offset: Offset(
                        (size * indexedDevice.$2.orbitFactor) *
                            math.cos(
                              _driftAngle(
                                indexedDevice.$2.angle,
                                indexedDevice.$1,
                              ),
                            ),
                        (size * indexedDevice.$2.orbitFactor) *
                            math.sin(
                              _driftAngle(
                                indexedDevice.$2.angle,
                                indexedDevice.$1,
                              ),
                            ),
                      ),
                      child: DeviceBubble(
                        device: indexedDevice.$2,
                        highlightValue: _highlightValue(
                          sweepAngle,
                          _driftAngle(indexedDevice.$2.angle, indexedDevice.$1),
                        ),
                        onTap: () => _showDeviceSheet(indexedDevice.$2),
                      ),
                    ),
                  child!,
                ],
              );
            },
            child: const Center(child: AppLogo(size: 88)),
          ),
        ),
      ),
    );
  }

  void _showDeviceSheet(MockNearbyDevice device) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: false,
      builder: (context) => DeviceActionSheet(device: device),
    );
  }

  double _driftAngle(double baseAngle, int index) {
    final direction = index.isEven ? 1 : -1;
    return baseAngle + (_orbitController.value * math.pi * 2 * direction);
  }

  double _highlightValue(double sweepAngle, double deviceAngle) {
    const highlightRange = 0.52;
    final distance = _angleDistance(sweepAngle, deviceAngle);
    return (1 - (distance / highlightRange)).clamp(0, 1);
  }

  double _angleDistance(double firstAngle, double secondAngle) {
    final difference = (firstAngle - secondAngle).abs() % (math.pi * 2);
    return difference > math.pi ? (math.pi * 2) - difference : difference;
  }
}
