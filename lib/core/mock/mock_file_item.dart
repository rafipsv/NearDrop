import 'package:flutter/widgets.dart';

class MockFileItem {
  const MockFileItem({
    required this.name,
    required this.type,
    required this.sizeLabel,
    required this.icon,
  });

  final String name;
  final String type;
  final String sizeLabel;
  final IconData icon;
}
