import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/file_size_formatter.dart';
import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
import '../../../../core/widgets/status_chip.dart';
import '../bloc/transfer_bloc.dart';
import '../bloc/transfer_event.dart';
import '../bloc/transfer_state.dart';
import 'transfer_progress_ring.dart';
import 'transfer_stat_grid.dart';

class TransferContent extends StatelessWidget {
  const TransferContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        final progress = state.progress;
        final percent = progress?.percentage ?? 0.0;
        final currentFile = state.files
            .where((file) => file.id == progress?.fileId)
            .firstOrNull;
        final title = state is TransferSuccess
            ? 'Transfer complete'
            : state is TransferFailure
            ? 'Transfer failed'
            : state is ReceiverPreparing
            ? 'Preparing receiver'
            : currentFile == null
            ? 'Waiting for transfer'
            : 'Receiving ${currentFile.name}';

        return ListView(
          padding: EdgeInsets.all(20.r),
          children: [
            SectionPanel(
              child: Column(
                children: [
                  StatusChip(
                    label: state is TransferSuccess
                        ? 'Completed'
                        : state is TransferFailure
                        ? 'Needs attention'
                        : 'Local Wi-Fi session',
                    icon: state is TransferSuccess
                        ? Icons.check_circle_rounded
                        : state is TransferFailure
                        ? Icons.error_rounded
                        : Icons.wifi_rounded,
                    color: state is TransferFailure
                        ? colorScheme.error
                        : colorScheme.primary,
                  ),
                  const VerticalGap(22),
                  TransferProgressRing(progress: percent),
                  const VerticalGap(20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const VerticalGap(6),
                  Text(
                    _subtitle(state),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalGap(16),
            progress == null
                ? const SectionPanel(child: TransferStatGrid())
                : SectionPanel(child: _LiveTransferStats(state: state)),
            if (state is TransferFailure) ...[
              const VerticalGap(16),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
              ),
            ],
            const VerticalGap(16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<TransferBloc>().add(
                      const CancelTransfer(),
                    ),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Cancel'),
                  ),
                ),
                const HorizontalGap(12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () =>
                        context.read<TransferBloc>().add(const RetryTransfer()),
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _subtitle(TransferState state) {
    if (state is TransferSuccess) {
      return 'Files were saved locally on this device.';
    }
    if (state is TransferFailure) {
      return 'Check both devices are on the same Wi-Fi and try again.';
    }
    if (state is ReceiverPreparing) {
      return 'Reading QR data and connecting to the sender.';
    }
    return 'No cloud upload. Direct device-to-device transfer.';
  }
}

class _LiveTransferStats extends StatelessWidget {
  const _LiveTransferStats({required this.state});

  final TransferState state;

  @override
  Widget build(BuildContext context) {
    final progress = state.progress;
    if (progress == null) return const TransferStatGrid();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _Stat(
                label: 'Transferred',
                value:
                    '${FileSizeFormatter.formatBytes(progress.transferredBytes)} / ${FileSizeFormatter.formatBytes(progress.totalBytes)}',
                icon: Icons.download_rounded,
              ),
            ),
            const HorizontalGap(10),
            Expanded(
              child: _Stat(
                label: 'Speed',
                value:
                    '${FileSizeFormatter.formatBytes(progress.speedBytesPerSecond.round())}/s',
                icon: Icons.speed_rounded,
              ),
            ),
          ],
        ),
        const VerticalGap(10),
        Row(
          children: [
            Expanded(
              child: _Stat(
                label: 'Remaining',
                value: progress.estimatedRemainingSeconds == null
                    ? '--'
                    : '${progress.estimatedRemainingSeconds}s',
                icon: Icons.timer_rounded,
              ),
            ),
            const HorizontalGap(10),
            Expanded(
              child: _Stat(
                label: 'Files',
                value: '${state.files.length}',
                icon: Icons.library_add_check_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(minHeight: 82.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary, size: 20.r),
          const VerticalGap(8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
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
    );
  }
}
