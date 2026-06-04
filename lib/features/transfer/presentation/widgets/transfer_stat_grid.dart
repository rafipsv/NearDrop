import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'transfer_stat_tile.dart';

class TransferStatGrid extends StatelessWidget {
  const TransferStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 2.5,
      ),
      children: const [
        TransferStatTile(label: 'Transferred', value: '12.4 MB / 26.1 MB'),
        TransferStatTile(label: 'Speed', value: '3.2 MB/s'),
        TransferStatTile(label: 'Remaining', value: 'About 5 sec'),
        TransferStatTile(label: 'Receiver', value: "Mira's Pixel"),
      ],
    );
  }
}
