import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
import '../../../../core/widgets/status_chip.dart';
import '../bloc/transfer_bloc.dart';
import '../bloc/transfer_state.dart';
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

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        SectionPanel(
          child: Column(
            children: [
              const MockQrCode(),
              const VerticalGap(22),
              Text('Scan to receive', style: textTheme.headlineSmall),
              const VerticalGap(6),
              Text(
                '${AppConstants.appName} on 192.168.0.105:8080',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const VerticalGap(14),
              const StatusChip(
                label: 'Waiting for receiver',
                icon: Icons.hourglass_top_rounded,
              ),
            ],
          ),
        ),
        const VerticalGap(16),
        BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            if (state.files.isEmpty) {
              return const SectionPanel(child: FilePickerEmptyState());
            }

            return SectionPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sharing files', style: textTheme.titleMedium),
                  const VerticalGap(4),
                  FileSelectionSummary(files: state.files),
                  const VerticalGap(8),
                  for (final file in state.files) SelectedFileTile(file: file),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
