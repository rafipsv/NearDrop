import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/mock/mock_nearby_device.dart';
import '../../domain/entities/device_platform.dart';
import '../../domain/entities/device_status.dart';

class DeviceBubble extends StatelessWidget {
  const DeviceBubble({
    super.key,
    required this.device,
    required this.highlightValue,
    required this.onTap,
  });

  final MockNearbyDevice device;
  final double highlightValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(device.colorValue);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlightColor = isDark
        ? Color.lerp(color, Colors.white, 0.36)!
        : Color.lerp(color, Colors.white, 0.08)!;
    final glowOpacity = (isDark ? 0.4 : 0.34) + (highlightValue * 0.72);
    final glowBlur = 18.r + (highlightValue * (isDark ? 32.r : 34.r));
    final borderWidth = 1.2.r + (highlightValue * (isDark ? 3.6.r : 4.r));
    final borderOpacity = (isDark ? 0.34 : 0.34) + (highlightValue * 0.74);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 58.r,
        height: 58.r,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 58.r,
              height: 58.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(
                  color: highlightColor.withValues(alpha: borderOpacity),
                  width: borderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: highlightColor.withValues(alpha: glowOpacity),
                    blurRadius: glowBlur,
                    offset: Offset(0, 8.h),
                  ),
                  if (highlightValue > 0)
                    BoxShadow(
                      color: highlightColor.withValues(
                        alpha: highlightValue * (isDark ? 0.5 : 0.46),
                      ),
                      blurRadius: isDark ? 52.r : 54.r,
                      spreadRadius: isDark ? 6.r : 7.r,
                    ),
                ],
              ),
              child: Icon(_platformIcon, color: Colors.white, size: 26.r),
            ),
            Positioned(
              top: 66.h,
              child: SizedBox(
                width: 96.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      device.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
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
