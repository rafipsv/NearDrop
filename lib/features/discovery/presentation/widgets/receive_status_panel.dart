import 'package:flutter/material.dart';

import '../../../../core/widgets/responsive_gap.dart';
import '../../../../core/widgets/status_chip.dart';

class ReceiveStatusPanel extends StatelessWidget {
  const ReceiveStatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 8,
      children: [
        StatusChip(label: 'Receive mode on', icon: Icons.download_rounded),
        HorizontalGap(10),
        StatusChip(label: 'Manual IP', icon: Icons.link_rounded),
      ],
    );
  }
}
