import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/file_item_entity.dart';

class SelectedFileTile extends StatelessWidget {
  const SelectedFileTile({super.key, required this.file, this.onRemove});

  final FileItemEntity file;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      leading: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(_fileIcon, color: colorScheme.primary, size: 22.r),
      ),
      title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${file.mimeType} - ${FileSizeFormatter.formatBytes(file.size)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: onRemove == null
          ? null
          : IconButton(
              tooltip: 'Remove',
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded),
            ),
    );
  }

  IconData get _fileIcon {
    if (file.mimeType.startsWith('image/')) return Icons.image_rounded;
    if (file.mimeType.startsWith('video/')) return Icons.movie_rounded;
    if (file.mimeType.startsWith('audio/')) return Icons.audio_file_rounded;
    if (file.mimeType == 'application/pdf') {
      return Icons.picture_as_pdf_rounded;
    }
    if (file.mimeType.contains('zip') || file.mimeType.contains('archive')) {
      return Icons.folder_zip_rounded;
    }
    return Icons.insert_drive_file_rounded;
  }
}
