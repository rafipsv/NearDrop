import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeActionBar extends StatelessWidget {
  const HomeActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file_rounded),
            label: const Text('Send files'),
          ),
        ),
        SizedBox(width: 12.w),
        IconButton.filledTonal(
          tooltip: 'QR fallback',
          onPressed: () {},
          icon: const Icon(Icons.qr_code_2_rounded),
        ),
      ],
    );
  }
}
