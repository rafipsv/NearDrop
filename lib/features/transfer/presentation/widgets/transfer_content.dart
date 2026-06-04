import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
import '../../../../core/widgets/status_chip.dart';
import 'transfer_progress_ring.dart';
import 'transfer_stat_grid.dart';

class TransferContent extends StatelessWidget {
  const TransferContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        SectionPanel(
          child: Column(
            children: [
              const StatusChip(
                label: 'Local Wi-Fi session',
                icon: Icons.wifi_rounded,
              ),
              const VerticalGap(22),
              const TransferProgressRing(progress: 0.47),
              const VerticalGap(20),
              Text(
                'Sending photo_001.png',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const VerticalGap(6),
              Text(
                'No cloud upload. Direct device-to-device transfer.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const VerticalGap(16),
        const SectionPanel(child: TransferStatGrid()),
        const VerticalGap(16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.close_rounded),
                label: const Text('Cancel'),
              ),
            ),
            const HorizontalGap(12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Retry mock'),
              ),
            ),
          ],
        ),
        const VerticalGap(16),
        SectionPanel(
          child: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: colorScheme.tertiary),
              const HorizontalGap(10),
              Expanded(
                child: Text(
                  'Success and error animations will attach to real transfer states in Phase 7.',
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
