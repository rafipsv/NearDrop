import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_app_bar.dart';
import '../widgets/transfer_content.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FeatureAppBar(title: 'Transfer'),
      body: TransferContent(),
    );
  }
}
