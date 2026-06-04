import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_app_bar.dart';
import '../widgets/qr_send_content.dart';

class QrSendPage extends StatelessWidget {
  const QrSendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FeatureAppBar(title: 'QR Send'),
      body: QrSendContent(),
    );
  }
}
