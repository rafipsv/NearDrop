import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_back_button.dart';

class FeatureAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FeatureAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBackButton(),
      title: Text(title),
      actions: actions,
    );
  }
}
