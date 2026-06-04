import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/discovery_bloc.dart';
import '../bloc/discovery_state.dart';

class DiscoveryStatusText extends StatelessWidget {
  const DiscoveryStatusText({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<DiscoveryBloc, DiscoveryState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            state is DiscoveryScanning
                ? 'Scanning for NearDrop devices...'
                : 'No nearby devices found yet.',
            key: ValueKey(state.runtimeType),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        );
      },
    );
  }
}
