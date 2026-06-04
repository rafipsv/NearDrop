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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.w),
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final size = 420.w;
              return Stack(
                alignment: Alignment.center,
                children: [
                  RadarRings(sweepAngle: _controller.value * 6.28318),
                  for (final device in MockData.nearbyDevices)
                    Transform.translate(
                      offset: Offset(
                        (size * device.orbitFactor) * math.cos(device.angle),
                        (size * device.orbitFactor) * math.sin(device.angle),
                      ),
                      child: DeviceBubble(
                        device: device,
                        animationValue: math.sin(
                          (_controller.value * 6.28318) + device.angle,
                        ),
                        onTap: () => _showDeviceSheet(device),
                      ),
                    ),
                  child!,
                ],
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(size: 88),
                SizedBox(height: 18.h),
                Text('Searching nearby', style: textTheme.titleLarge),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 220.w,
                  child: Text(
                    'Make sure both devices are on the same Wi-Fi.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
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
}
