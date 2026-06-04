import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/mock/mock_nearby_device.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/status_chip.dart';

class DeviceActionSheet extends StatelessWidget {
  const DeviceActionSheet({super.key, required this.device});

  final MockNearbyDevice device;

  @override
  Widget build(BuildContext context) {
    final color = Color(device.colorValue);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ),
          const VerticalGap(20),
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: color,
                child: Icon(
                  Icons.devices_rounded,
                  color: Colors.white,
                  size: 26.r,
                ),
              ),
              const HorizontalGap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.name, style: textTheme.titleLarge),
                    const VerticalGap(4),
                    const StatusChip(
                      label: 'Ready for local transfer',
                      icon: Icons.wifi_tethering_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VerticalGap(22),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    context.pop();
                    context.go(AppRoutes.files);
                  },
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Send files'),
                ),
              ),
              const HorizontalGap(12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.pop();
                    context.go(AppRoutes.transfer);
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Receive'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
