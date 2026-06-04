import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(dimension: size.r);
}

class VerticalGap extends StatelessWidget {
  const VerticalGap(this.height, {super.key});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height.h);
}

class HorizontalGap extends StatelessWidget {
  const HorizontalGap(this.width, {super.key});

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width.w);
}
