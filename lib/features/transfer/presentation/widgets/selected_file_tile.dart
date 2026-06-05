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
    final textTheme = Theme.of(context).textTheme;
    final accentColor = _accentColor(context);
    final sizeLabel = FileSizeFormatter.formatBytes(file.size);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: accentColor.withValues(alpha: 0.12),
              border: Border.all(color: accentColor.withValues(alpha: 0.18)),
            ),
            child: Icon(_fileIcon, color: accentColor, size: 22.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        child: Text(
                          _typeLabel,
                          style: textTheme.labelMedium?.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        sizeLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onRemove != null) ...[
            SizedBox(width: 8.w),
            IconButton(
              tooltip: 'Remove',
              onPressed: onRemove,
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.62,
                ),
                fixedSize: Size(34.r, 34.r),
              ),
              icon: Icon(
                Icons.close_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 19.r,
              ),
            ),
          ],
        ],
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

  String get _typeLabel {
    if (file.mimeType.startsWith('image/')) return 'Image';
    if (file.mimeType.startsWith('video/')) return 'Video';
    if (file.mimeType.startsWith('audio/')) return 'Audio';
    if (file.mimeType == 'application/pdf') return 'PDF';
    if (file.mimeType.contains('zip') || file.mimeType.contains('archive')) {
      return 'Archive';
    }
    return 'File';
  }

  Color _accentColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (file.mimeType.startsWith('image/')) return const Color(0xFF2F80ED);
    if (file.mimeType.startsWith('video/')) return const Color(0xFF6C5CE7);
    if (file.mimeType.startsWith('audio/')) return const Color(0xFF16A3B8);
    if (file.mimeType == 'application/pdf') return colorScheme.error;
    if (file.mimeType.contains('zip') || file.mimeType.contains('archive')) {
      return const Color(0xFFF2994A);
    }
    return colorScheme.primary;
  }
}
