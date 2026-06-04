import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/mock/mock_file_item.dart';

class SelectedFileTile extends StatelessWidget {
  const SelectedFileTile({super.key, required this.file});

  final MockFileItem file;

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
        child: Icon(file.icon, color: colorScheme.primary, size: 22.r),
      ),
      title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${file.type} - ${file.sizeLabel}'),
      trailing: IconButton(
        tooltip: 'Remove',
        onPressed: () {},
        icon: const Icon(Icons.close_rounded),
      ),
    );
  }
}
