import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrScanFrame extends StatelessWidget {
  const QrScanFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.qr_code_scanner_rounded,
                size: 82.r,
                color: Colors.white.withValues(alpha: 0.76),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(22.r),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.tertiary, width: 2.r),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
