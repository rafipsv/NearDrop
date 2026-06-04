import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';

class HomeActionBar extends StatelessWidget {
  const HomeActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => context.go(AppRoutes.files),
            icon: const Icon(Icons.upload_file_rounded),
            label: const Text('Send files'),
          ),
        ),
        SizedBox(width: 12.w),
        IconButton.filledTonal(
          tooltip: 'QR fallback',
          onPressed: () => context.go(AppRoutes.qrScan),
          icon: const Icon(Icons.qr_code_2_rounded),
        ),
      ],
    );
  }
}
