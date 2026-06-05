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
    final successfulTransfers = MockData.history
        .where((item) => item.success)
        .length;
    final interruptedTransfers = MockData.history.length - successfulTransfers;

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        _HistoryHero(
          successfulTransfers: successfulTransfers,
          interruptedTransfers: interruptedTransfers,
        ),
        const VerticalGap(20),
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent transfers',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const StatusChip(label: 'Local only', icon: Icons.lock_rounded),
          ],
        ),
        const VerticalGap(12),
        SectionPanel(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            children: [
              for (final indexedItem in MockData.history.indexed) ...[
                HistoryItemTile(item: indexedItem.$2),
                if (indexedItem.$1 != MockData.history.length - 1)
                  Divider(
                    height: 1.h,
                    indent: 68.w,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.55),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryHero extends StatelessWidget {
  const _HistoryHero({
    required this.successfulTransfers,
    required this.interruptedTransfers,
  });

  final int successfulTransfers;
  final int interruptedTransfers;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: isDark ? 0.28 : 0.16),
            colorScheme.tertiary.withValues(alpha: isDark ? 0.22 : 0.12),
            colorScheme.surfaceContainerHighest.withValues(
              alpha: isDark ? 0.32 : 0.82,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withValues(alpha: 0.14),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    color: colorScheme.primary,
                    size: 24.r,
                  ),
                ),
                const HorizontalGap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transfer timeline',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const VerticalGap(4),
                      Text(
                        'Private activity saved on this device.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VerticalGap(18),
            Row(
              children: [
                Expanded(
                  child: _HistoryStat(
                    label: 'Completed',
                    value: '$successfulTransfers',
                    icon: Icons.check_circle_rounded,
                    color: colorScheme.tertiary,
                  ),
                ),
                const HorizontalGap(10),
                Expanded(
                  child: _HistoryStat(
                    label: 'Interrupted',
                    value: '$interruptedTransfers',
                    icon: Icons.error_rounded,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryStat extends StatelessWidget {
  const _HistoryStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.r),
          const HorizontalGap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
