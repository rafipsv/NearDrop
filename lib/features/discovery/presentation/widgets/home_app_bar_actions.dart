import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../settings/presentation/bloc/theme_bloc.dart';
import '../../../settings/presentation/bloc/theme_event.dart';

class HomeAppBarActions extends StatelessWidget {
  const HomeAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'History',
          onPressed: () => context.go(AppRoutes.history),
          icon: const Icon(Icons.history_rounded),
        ),
        IconButton(
          tooltip: 'Toggle theme',
          onPressed: () => context.read<ThemeBloc>().add(const ToggleTheme()),
          icon: const Icon(Icons.contrast_rounded),
        ),
        IconButton(
          tooltip: 'Settings',
          onPressed: () => context.go(AppRoutes.settings),
          icon: const Icon(Icons.settings_rounded),
        ),
      ],
    );
  }
}
