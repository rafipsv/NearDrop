import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'settings_header.dart';
import 'settings_option_tile.dart';
import 'theme_mode_selector.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        const SettingsHeader(),
        SizedBox(height: 28.h),
        const ThemeModeSelector(),
        SizedBox(height: 24.h),
        const SettingsOptionTile(
          icon: Icons.phone_iphone_rounded,
          title: 'Device name',
          subtitle: "Muhammad's iPhone",
        ),
        const SettingsOptionTile(
          icon: Icons.folder_rounded,
          title: 'Storage location',
          subtitle: 'Local downloads folder',
        ),
        const SettingsOptionTile(
          icon: Icons.cloud_off_rounded,
          title: 'Privacy',
          subtitle: 'No cloud upload or external storage server',
        ),
        const SettingsOptionTile(
          icon: Icons.info_outline_rounded,
          title: 'About',
          subtitle: 'NearDrop mock UI - Phase 2',
        ),
      ],
    );
  }
}
