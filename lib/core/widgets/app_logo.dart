import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsiveSize = size.r;

    return Container(
      width: responsiveSize,
      height: responsiveSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.28),
            blurRadius: responsiveSize * 0.28,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Icon(
        Icons.near_me_rounded,
        color: colorScheme.onPrimary,
        size: responsiveSize * 0.45,
      ),
    );
  }
}
