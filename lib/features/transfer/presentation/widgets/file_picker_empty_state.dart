import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/responsive_gap.dart';

class FilePickerEmptyState extends StatelessWidget {
  const FilePickerEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(Icons.upload_file_rounded, size: 46.r, color: colorScheme.primary),
        const VerticalGap(14),
        Text('No files selected', style: textTheme.titleLarge),
        const VerticalGap(6),
        Text(
          'Pick one or multiple files to create local transfer metadata.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
