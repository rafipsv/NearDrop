import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscoveryIntroText extends StatelessWidget {
  const DiscoveryIntroText({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Searching nearby', style: textTheme.titleLarge),
        SizedBox(height: 4.h),
        SizedBox(
          width: 240.w,
          child: Text(
            'Make sure both devices are on the same Wi-Fi.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11.sp,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
