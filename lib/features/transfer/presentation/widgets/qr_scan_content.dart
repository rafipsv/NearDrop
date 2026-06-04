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

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        const QrScanFrame(),
        const VerticalGap(18),
        SectionPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusChip(
                label: 'Camera scanner mock',
                icon: Icons.camera_alt_rounded,
              ),
              const VerticalGap(12),
              Text('Point at sender QR', style: textTheme.titleLarge),
              const VerticalGap(6),
              Text(
                'Phase 5 will connect this screen to real QR parsing and metadata download.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const VerticalGap(16),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_done_rounded),
                label: const Text('Confirm mock download'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
