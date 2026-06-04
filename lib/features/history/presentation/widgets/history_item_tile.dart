import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/mock/mock_history_item.dart';

class HistoryItemTile extends StatelessWidget {
  const HistoryItemTile({super.key, required this.item});

  final MockHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = item.success ? colorScheme.tertiary : colorScheme.error;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      leading: CircleAvatar(
        radius: 23.r,
        backgroundColor: statusColor.withValues(alpha: 0.12),
        child: Icon(
          item.direction == 'Sent'
              ? Icons.north_east_rounded
              : Icons.south_west_rounded,
          color: statusColor,
        ),
      ),
      title: Text(item.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${item.direction} to ${item.deviceName} - ${item.timeLabel}',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            item.fileSize,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4.h),
          Text(
            item.status,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: statusColor),
          ),
        ],
      ),
    );
  }
}
