import 'package:flutter/material.dart';

import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/file_item_entity.dart';

class FileSelectionSummary extends StatelessWidget {
  const FileSelectionSummary({super.key, required this.files});

  final List<FileItemEntity> files;

  @override
  Widget build(BuildContext context) {
    final totalBytes = files.fold<int>(0, (total, file) => total + file.size);

    return Text(
      '${files.length} selected - ${FileSizeFormatter.formatBytes(totalBytes)} total',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
