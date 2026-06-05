import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
import 'settings_header.dart';
import 'settings_option_tile.dart';
import 'theme_mode_selector.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        const SettingsHeader(),
        const VerticalGap(22),
        Text(
          'Appearance',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const VerticalGap(10),
        SectionPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _SectionIcon(
                    icon: Icons.palette_rounded,
                    color: colorScheme.primary,
                  ),
                  const HorizontalGap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme mode',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const VerticalGap(3),
                        Text(
                          'Match the system or choose your own look.',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const VerticalGap(16),
              const ThemeModeSelector(),
            ],
          ),
        ),
        const VerticalGap(22),
        Text(
          'Device',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const VerticalGap(10),
        SectionPanel(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Column(
            children: [
              const SettingsOptionTile(
                icon: Icons.phone_iphone_rounded,
                title: 'Device name',
                subtitle: "Muhammad's iPhone",
                color: Color(0xFF2F80ED),
              ),
              _SettingsDivider(color: colorScheme.outlineVariant),
              const SettingsOptionTile(
                icon: Icons.folder_rounded,
                title: 'Storage location',
                subtitle: 'Local downloads folder',
                color: Color(0xFF16A3B8),
              ),
            ],
          ),
        ),
        const VerticalGap(22),
        Text(
          'Trust',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const VerticalGap(10),
        SectionPanel(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Column(
            children: [
              const SettingsOptionTile(
                icon: Icons.cloud_off_rounded,
                title: 'Privacy',
                subtitle: 'No cloud upload or external storage server',
                color: Color(0xFF27AE60),
              ),
              _SettingsDivider(color: colorScheme.outlineVariant),
              const SettingsOptionTile(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'NearDrop mock UI - Phase 2',
                color: Color(0xFF6C5CE7),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionIcon extends StatelessWidget {
  const _SectionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
      ),
      child: Icon(icon, color: color, size: 21.r),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      indent: 62.w,
      color: color.withValues(alpha: 0.55),
    );
  }
}
