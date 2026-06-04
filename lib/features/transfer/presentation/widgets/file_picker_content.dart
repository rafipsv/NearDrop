import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/section_panel.dart';
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
              Text(
                'Mock file list for Phase 2. Real picker arrives in Phase 3.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const VerticalGap(18),
        SectionPanel(
          child: Column(
            children: [
              for (final file in MockData.selectedFiles)
                SelectedFileTile(file: file),
            ],
          ),
        ),
        const VerticalGap(18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.attach_file_rounded),
                label: const Text('Add more'),
              ),
            ),
            const HorizontalGap(12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => context.go(AppRoutes.qrSend),
                icon: const Icon(Icons.wifi_tethering_rounded),
                label: const Text('Start sharing'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
