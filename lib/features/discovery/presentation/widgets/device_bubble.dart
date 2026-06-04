import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/mock/mock_nearby_device.dart';
import '../../domain/entities/device_platform.dart';
import '../../domain/entities/device_status.dart';

class DeviceBubble extends StatelessWidget {
  const DeviceBubble({
    super.key,
    required this.device,
    required this.animationValue,
    required this.onTap,
  });

  final MockNearbyDevice device;
  final double animationValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(device.colorValue);
    final floatOffset = 5.h * animationValue;

    return Transform.translate(
      offset: Offset(0, floatOffset),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 58.r,
              height: 58.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.32),
                    blurRadius: 18.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Icon(_platformIcon, color: Colors.white, size: 26.r),
            ),
            SizedBox(height: 8.h),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 92.w),
              child: Text(
                device.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _statusLabel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _statusColor(context),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _platformIcon {
    return switch (device.platform) {
      DevicePlatform.android => Icons.android_rounded,
      DevicePlatform.ios => Icons.phone_iphone_rounded,
      DevicePlatform.unknown => Icons.devices_rounded,
    };
  }

  String get _statusLabel {
    return switch (device.status) {
      DeviceStatus.available => 'Available',
      DeviceStatus.connecting => 'Connecting',
      DeviceStatus.connected => 'Connected',
      DeviceStatus.unavailable => 'Away',
    };
  }

  Color _statusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (device.status) {
      DeviceStatus.connected => colorScheme.tertiary,
      DeviceStatus.available => colorScheme.primary,
      DeviceStatus.connecting => colorScheme.secondary,
      DeviceStatus.unavailable => colorScheme.onSurfaceVariant,
    };
  }
}
