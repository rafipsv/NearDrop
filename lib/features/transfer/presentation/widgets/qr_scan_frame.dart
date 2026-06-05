import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrScanFrame extends StatelessWidget {
  const QrScanFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: isDark ? 0.28 : 0.16),
            colorScheme.tertiary.withValues(alpha: isDark ? 0.18 : 0.1),
            colorScheme.surfaceContainerHighest.withValues(
              alpha: isDark ? 0.24 : 0.78,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.48),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF070B12),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 28.r,
                  offset: Offset(0, 16.h),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ScannerBackdropPainter(
                      color: colorScheme.primary.withValues(alpha: 0.18),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 108.r,
                    height: 108.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 56.r,
                      color: Colors.white.withValues(alpha: 0.84),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(28.r),
                    child: CustomPaint(
                      painter: _ScannerCornersPainter(
                        color: colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 34.w,
                  right: 34.w,
                  top: 104.h,
                  child: Container(
                    height: 2.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999.r),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          colorScheme.tertiary,
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.tertiary.withValues(alpha: 0.7),
                          blurRadius: 16.r,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 18.w,
                  right: 18.w,
                  bottom: 18.h,
                  child: _ScannerStatusPill(color: colorScheme.tertiary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScannerStatusPill extends StatelessWidget {
  const _ScannerStatusPill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt_rounded, color: color, size: 15.r),
              SizedBox(width: 7.w),
              Text(
                'Align QR inside frame',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerBackdropPainter extends CustomPainter {
  const _ScannerBackdropPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    final spacing = size.width / 7;
    for (var index = 1; index < 7; index++) {
      final position = spacing * index;
      canvas.drawLine(
        Offset(position, 0),
        Offset(position, size.height),
        paint,
      );
      canvas.drawLine(Offset(0, position), Offset(size.width, position), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScannerBackdropPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _ScannerCornersPainter extends CustomPainter {
  const _ScannerCornersPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final length = 38.r;
    final radius = 8.r;

    final corners = [
      (
        Offset.zero,
        Offset(length, 0),
        Offset(0, length),
        Radius.circular(radius),
      ),
      (
        Offset(size.width, 0),
        Offset(size.width - length, 0),
        Offset(size.width, length),
        Radius.circular(radius),
      ),
      (
        Offset(0, size.height),
        Offset(length, size.height),
        Offset(0, size.height - length),
        Radius.circular(radius),
      ),
      (
        Offset(size.width, size.height),
        Offset(size.width - length, size.height),
        Offset(size.width, size.height - length),
        Radius.circular(radius),
      ),
    ];

    for (final corner in corners) {
      final path = Path()
        ..moveTo(corner.$2.dx, corner.$2.dy)
        ..arcToPoint(corner.$1, radius: corner.$4)
        ..arcToPoint(corner.$3, radius: corner.$4);
      canvas.drawPath(path, paint);
    }

    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.24)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(8.r)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerCornersPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
