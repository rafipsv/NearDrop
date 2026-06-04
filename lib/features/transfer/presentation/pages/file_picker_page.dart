import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_app_bar.dart';
import '../widgets/file_picker_content.dart';

class FilePickerPage extends StatelessWidget {
  const FilePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FeatureAppBar(title: 'Files'),
      body: FilePickerContent(),
    );
  }
}
