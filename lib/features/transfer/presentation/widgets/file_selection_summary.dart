import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/file_item_entity.dart';

class FileSelectionSummary extends StatelessWidget {
  const FileSelectionSummary({super.key, required this.files});

  final List<FileItemEntity> files;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final totalBytes = files.fold<int>(0, (total, file) => total + file.size);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.done_all_rounded,
              color: colorScheme.primary,
              size: 15.r,
            ),
            SizedBox(width: 7.w),
            Flexible(
              child: Text(
                '${files.length} selected - ${FileSizeFormatter.formatBytes(totalBytes)} total',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
