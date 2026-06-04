import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_app_bar.dart';
import '../widgets/qr_scan_content.dart';

class QrScanPage extends StatelessWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FeatureAppBar(title: 'QR Scan'),
      body: QrScanContent(),
    );
  }
}
