import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
import '../../../../core/widgets/status_chip.dart';
import '../bloc/transfer_bloc.dart';
import '../bloc/transfer_state.dart';
import '../../domain/entities/file_item_entity.dart';
import 'file_picker_empty_state.dart';
import 'file_selection_summary.dart';
import 'mock_qr_code.dart';
import 'selected_file_tile.dart';

class QrSendContent extends StatelessWidget {
  const QrSendContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            return _QrSendHero(files: state.files, isDark: isDark);
          },
        ),
        const VerticalGap(20),
        BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            if (state.files.isEmpty) {
              return const FilePickerEmptyState();
            }

            return SectionPanel(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sharing queue',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        FileSelectionSummary(files: state.files),
                      ],
                    ),
                  ),
                  for (final indexedFile in state.files.indexed) ...[
                    SelectedFileTile(file: indexedFile.$2),
                    if (indexedFile.$1 != state.files.length - 1)
                      Divider(
                        height: 1.h,
                        indent: 62.w,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.55,
                        ),
                      ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QrSendHero extends StatelessWidget {
  const _QrSendHero({required this.files, required this.isDark});

  final List<FileItemEntity> files;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final totalBytes = files.fold<int>(0, (total, file) => total + file.size);
    final totalLabel = FileSizeFormatter.formatBytes(totalBytes);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: isDark ? 0.28 : 0.16),
            colorScheme.tertiary.withValues(alpha: isDark ? 0.22 : 0.12),
            colorScheme.surfaceContainerHighest.withValues(
              alpha: isDark ? 0.32 : 0.84,
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Icons.qr_code_2_rounded,
                    color: colorScheme.primary,
                    size: 27.r,
                  ),
                ),
                const HorizontalGap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan to receive',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const VerticalGap(4),
                      Text(
                        '${AppConstants.appName} on 192.168.0.105:8080',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VerticalGap(20),
            const MockQrCode(),
            const VerticalGap(18),
            Row(
              children: [
                Expanded(
                  child: _QrSendStat(
                    label: 'Files',
                    value: '${files.length}',
                    icon: Icons.library_add_check_rounded,
                    color: colorScheme.primary,
                  ),
                ),
                const HorizontalGap(10),
                Expanded(
                  child: _QrSendStat(
                    label: 'Package',
                    value: files.isEmpty ? '0 B' : totalLabel,
                    icon: Icons.data_usage_rounded,
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const VerticalGap(14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const StatusChip(
                  label: 'Waiting for receiver',
                  icon: Icons.hourglass_top_rounded,
                ),
                const HorizontalGap(8),
                StatusChip(
                  label: 'Local link',
                  icon: Icons.wifi_rounded,
                  color: colorScheme.tertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QrSendStat extends StatelessWidget {
  const _QrSendStat({
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
