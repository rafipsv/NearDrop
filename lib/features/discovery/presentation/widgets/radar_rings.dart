import 'package:flutter/material.dart';

class RadarRings extends StatelessWidget {
  const RadarRings({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomPaint(
      painter: _RadarRingsPainter(
        outerColor: colorScheme.primary.withValues(alpha: 0.22),
        innerColor: colorScheme.primary.withValues(alpha: 0.12),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _RadarRingsPainter extends CustomPainter {
  const _RadarRingsPainter({
    required this.outerColor,
    required this.innerColor,
  });

  final Color outerColor;
  final Color innerColor;

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

    for (var index = 1; index <= ringCount; index++) {
      ringPaint.color = index == ringCount ? outerColor : innerColor;
      canvas.drawCircle(center, radiusGap * index, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarRingsPainter oldDelegate) {
    return outerColor != oldDelegate.outerColor ||
        innerColor != oldDelegate.innerColor;
  }
}
