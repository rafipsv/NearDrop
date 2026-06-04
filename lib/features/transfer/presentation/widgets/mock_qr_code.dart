import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MockQrCode extends StatelessWidget {
  const MockQrCode({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 220.r,
      height: 220.r,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.16),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: CustomPaint(painter: _MockQrPainter()),
    );
  }
}

class _MockQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF111827);
    const cells = 13;
    final cellSize = size.width / cells;
    const filled = {
      0,
      1,
      2,
      4,
      5,
      8,
      10,
      11,
      12,
      13,
      15,
      17,
      19,
      22,
      24,
      26,
      27,
      28,
      31,
      34,
      36,
      37,
      38,
      41,
      43,
      45,
      46,
      48,
      50,
      52,
      55,
      58,
      60,
      62,
      64,
      66,
      67,
      69,
      70,
      73,
      76,
      78,
      81,
      83,
      85,
      87,
      90,
      92,
      93,
      96,
      99,
      101,
      103,
      105,
      108,
      110,
      111,
      114,
      116,
      118,
      119,
      120,
      123,
      126,
      127,
      128,
      130,
      132,
      134,
      136,
      138,
      140,
      143,
      145,
      147,
      149,
      151,
      153,
      156,
      157,
      158,
      160,
      163,
      166,
      168,
    };

    for (var index = 0; index < cells * cells; index++) {
      if (!filled.contains(index)) continue;
      final x = (index % cells) * cellSize;
      final y = (index ~/ cells) * cellSize;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, cellSize * 0.82, cellSize * 0.82),
          Radius.circular(cellSize * 0.16),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
