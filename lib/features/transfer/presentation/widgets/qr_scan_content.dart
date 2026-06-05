import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
import '../../../../core/widgets/status_chip.dart';
import 'qr_scan_frame.dart';

class QrScanContent extends StatelessWidget {
  const QrScanContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: isDark ? 0.26 : 0.15),
                colorScheme.tertiary.withValues(alpha: isDark ? 0.2 : 0.11),
                colorScheme.surfaceContainerHighest.withValues(
                  alpha: isDark ? 0.3 : 0.84,
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
            padding: EdgeInsets.all(18.r),
            child: Row(
              children: [
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withValues(alpha: 0.14),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: colorScheme.primary,
                    size: 26.r,
                  ),
                ),
                const HorizontalGap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Receive by QR',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const VerticalGap(4),
                      Text(
                        'Scan a sender code to fetch local transfer metadata.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalGap(20),
        const QrScanFrame(),
        const VerticalGap(20),
        SectionPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const StatusChip(
                    label: 'Scanner mock',
                    icon: Icons.camera_alt_rounded,
                  ),
                  const HorizontalGap(8),
                  StatusChip(
                    label: 'Local receive',
                    icon: Icons.wifi_rounded,
                    color: colorScheme.tertiary,
                  ),
                ],
              ),
              const VerticalGap(16),
              Text(
                'Point at sender QR',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const VerticalGap(7),
              Text(
                'Keep the QR code centered inside the frame. The receiver will prepare a private same-Wi-Fi download session.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const VerticalGap(18),
              Row(
                children: [
                  Expanded(
                    child: _ScanHint(
                      icon: Icons.center_focus_strong_rounded,
                      title: 'Center',
                      color: colorScheme.primary,
                    ),
                  ),
                  const HorizontalGap(10),
                  Expanded(
                    child: _ScanHint(
                      icon: Icons.light_mode_rounded,
                      title: 'Good light',
                      color: colorScheme.tertiary,
                    ),
                  ),
                  const HorizontalGap(10),
                  Expanded(
                    child: _ScanHint(
                      icon: Icons.lock_rounded,
                      title: 'Private',
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const VerticalGap(18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_done_rounded),
                  label: const Text('Confirm mock download'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScanHint extends StatelessWidget {
  const _ScanHint({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(minHeight: 72.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20.r),
          SizedBox(height: 7.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
