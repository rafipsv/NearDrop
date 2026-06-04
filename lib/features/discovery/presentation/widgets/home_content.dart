import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'discovery_scan_area.dart';
import 'discovery_status_text.dart';
import 'home_action_bar.dart';
import 'receive_status_panel.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        child: Column(
          children: [
            const Expanded(child: DiscoveryScanArea()),
            const DiscoveryStatusText(),
            SizedBox(height: 14.h),
            const ReceiveStatusPanel(),
            SizedBox(height: 18.h),
            const HomeActionBar(),
          ],
        ),
      ),
    );
  }
}
