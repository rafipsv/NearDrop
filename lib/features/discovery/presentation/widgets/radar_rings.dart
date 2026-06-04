import 'package:flutter/material.dart';

class RadarRings extends StatelessWidget {
  const RadarRings({super.key, required this.sweepAngle});

  final double sweepAngle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomPaint(
      painter: _RadarRingsPainter(
        outerColor: colorScheme.primary.withValues(alpha: 0.22),
        innerColor: colorScheme.primary.withValues(alpha: 0.12),
        sweepColor: colorScheme.tertiary.withValues(alpha: 0.34),
        sweepAngle: sweepAngle,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _RadarRingsPainter extends CustomPainter {
  const _RadarRingsPainter({
    required this.outerColor,
    required this.innerColor,
    required this.sweepColor,
    required this.sweepAngle,
  });

  final Color outerColor;
  final Color innerColor;
  final Color sweepColor;
  final double sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;
    final strokeWidth = 1.0;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    const ringCount = 4;
    final radiusGap = (maxRadius - strokeWidth) / ringCount;

    for (var index = 2; index <= ringCount; index++) {
      ringPaint.color = index == ringCount ? outerColor : innerColor;
      canvas.drawCircle(center, radiusGap * index, ringPaint);
    }

    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          sweepColor.withValues(alpha: 0),
          sweepColor,
          sweepColor.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.08, 0.16],
        transform: GradientRotation(sweepAngle),
      ).createShader(Offset.zero & size);

    canvas.drawCircle(center, maxRadius, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarRingsPainter oldDelegate) {
    return outerColor != oldDelegate.outerColor ||
        innerColor != oldDelegate.innerColor ||
        sweepColor != oldDelegate.sweepColor ||
        sweepAngle != oldDelegate.sweepAngle;
  }
}
