import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
import '../../../../core/widgets/status_chip.dart';
import '../bloc/transfer_bloc.dart';
import '../bloc/transfer_event.dart';
import '../bloc/transfer_state.dart';
import '../../domain/entities/file_item_entity.dart';
import 'file_picker_empty_state.dart';
import 'file_selection_summary.dart';
import 'selected_file_tile.dart';

class FilePickerContent extends StatelessWidget {
  const FilePickerContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            return _FilePickerHero(files: state.files);
          },
        ),
        const VerticalGap(20),
        BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            if (state is FilePicking) {
              return SectionPanel(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const VerticalGap(16),
                      Text(
                        'Opening file browser',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const VerticalGap(4),
                      Text(
                        'Your files stay on this device until sharing starts.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

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
                            'Selection queue',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        StatusChip(
                          label: '${state.files.length} files',
                          icon: Icons.library_add_check_rounded,
                        ),
                      ],
                    ),
                  ),
                  for (final indexedFile in state.files.indexed) ...[
                    SelectedFileTile(
                      file: indexedFile.$2,
                      onRemove: () => context.read<TransferBloc>().add(
                        RemoveSelectedFile(indexedFile.$2.id),
                      ),
                    ),
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
        const VerticalGap(20),
        BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            final isPicking = state is FilePicking;
            final hasFiles = state.files.isNotEmpty;

            return SectionPanel(
              padding: EdgeInsets.all(14.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isPicking
                              ? null
                              : () => context.read<TransferBloc>().add(
                                  const PickFiles(allowMultiple: false),
                                ),
                          icon: const Icon(Icons.insert_drive_file_rounded),
                          label: const Text('Pick one'),
                        ),
                      ),
                      const HorizontalGap(12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isPicking
                              ? null
                              : () => context.read<TransferBloc>().add(
                                  const PickFiles(),
                                ),
                          icon: const Icon(Icons.library_add_rounded),
                          label: const Text('Pick multiple'),
                        ),
                      ),
                    ],
                  ),
                  const VerticalGap(12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: hasFiles
                              ? () => context.read<TransferBloc>().add(
                                  const ClearSelectedFiles(),
                                )
                              : null,
                          icon: const Icon(Icons.delete_sweep_rounded),
                          label: const Text('Clear'),
                        ),
                      ),
                      const HorizontalGap(12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: hasFiles
                              ? () => context.push(AppRoutes.qrSend)
                              : null,
                          icon: const Icon(Icons.wifi_tethering_rounded),
                          label: const Text('Start sharing'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            if (state is! TransferFailure) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FilePickerHero extends StatelessWidget {
  const _FilePickerHero({required this.files});

  final List<FileItemEntity> files;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    Icons.add_to_drive_rounded,
                    size: 26.r,
                    color: colorScheme.primary,
                  ),
                ),
                const HorizontalGap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ready to share',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const VerticalGap(4),
                      Text(
                        'Choose local files and create a private transfer link.',
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
                  child: _PickerStat(
                    label: 'Selected',
                    value: '${files.length}',
                    icon: Icons.library_add_check_rounded,
                    color: colorScheme.primary,
                  ),
                ),
                const HorizontalGap(10),
                Expanded(
                  child: _PickerStat(
                    label: 'Total size',
                    value: files.isEmpty ? '0 B' : totalLabel,
                    icon: Icons.data_usage_rounded,
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            if (files.isNotEmpty) ...[
              const VerticalGap(14),
              FileSelectionSummary(files: files),
            ],
          ],
        ),
      ),
    );
  }
}

class _PickerStat extends StatelessWidget {
  const _PickerStat({
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
