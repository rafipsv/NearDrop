import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_app_bar.dart';
import '../widgets/history_content.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FeatureAppBar(title: 'History'),
      body: HistoryContent(),
    );
  }
}
