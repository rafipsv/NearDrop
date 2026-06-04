import 'package:flutter/material.dart';

import 'app/file_drop_app.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const FileDropApp());
}
