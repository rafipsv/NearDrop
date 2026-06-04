import 'package:flutter/material.dart';

import '../widgets/settings_app_bar.dart';
import '../widgets/settings_content.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: const SettingsContent(),
    );
  }
}
