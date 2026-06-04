import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
import '../bloc/transfer_bloc.dart';
import '../bloc/transfer_event.dart';
import '../bloc/transfer_state.dart';
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
        SectionPanel(
          child: Column(
            children: [
              Icon(
                Icons.add_to_drive_rounded,
                size: 46.r,
                color: colorScheme.primary,
              ),
              const VerticalGap(14),
              Text('Selected files', style: textTheme.headlineSmall),
              const VerticalGap(6),
              BlocBuilder<TransferBloc, TransferState>(
                builder: (context, state) {
                  return state.files.isEmpty
                      ? Text(
                          'Choose files from this device. Nothing is uploaded.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      : FileSelectionSummary(files: state.files);
                },
              ),
            ],
          ),
        ),
        const VerticalGap(18),
        BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            if (state is FilePicking) {
              return const SectionPanel(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state.files.isEmpty) {
              return const SectionPanel(child: FilePickerEmptyState());
            }

            return SectionPanel(
              child: Column(
                children: [
                  for (final file in state.files)
                    SelectedFileTile(
                      file: file,
                      onRemove: () => context.read<TransferBloc>().add(
                        RemoveSelectedFile(file.id),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const VerticalGap(18),
        BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            final isPicking = state is FilePicking;
            final hasFiles = state.files.isNotEmpty;

            return Column(
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
                            ? () => context.go(AppRoutes.qrSend)
                            : null,
                        icon: const Icon(Icons.wifi_tethering_rounded),
                        label: const Text('Start sharing'),
                      ),
                    ),
                  ],
                ),
              ],
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
