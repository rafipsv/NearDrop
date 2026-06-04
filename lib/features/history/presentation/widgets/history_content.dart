import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
import '../../../../core/widgets/status_chip.dart';
import 'history_item_tile.dart';

class HistoryContent extends StatelessWidget {
  const HistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        SectionPanel(
          child: Row(
            children: [
              Icon(Icons.lock_rounded, color: colorScheme.primary, size: 32.r),
              const HorizontalGap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Local history', style: textTheme.titleLarge),
                    const VerticalGap(4),
                    Text(
                      'Stored only on this device in a later phase.',
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
        const VerticalGap(16),
        const StatusChip(label: 'Mock history', icon: Icons.history_rounded),
        const VerticalGap(10),
        SectionPanel(
          child: Column(
            children: [
              for (final item in MockData.history) HistoryItemTile(item: item),
            ],
          ),
        ),
      ],
    );
  }
}
