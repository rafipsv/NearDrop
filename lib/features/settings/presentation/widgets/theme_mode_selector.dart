import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              value: ThemeMode.system,
              icon: Icon(Icons.brightness_auto_rounded),
              label: Text('System'),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              icon: Icon(Icons.light_mode_rounded),
              label: Text('Light'),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              icon: Icon(Icons.dark_mode_rounded),
              label: Text('Dark'),
            ),
          ],
          selected: {state.themeMode},
          onSelectionChanged: (selection) {
            final mode = selection.first;
            final bloc = context.read<ThemeBloc>();
            switch (mode) {
              case ThemeMode.system:
                bloc.add(const SetSystemTheme());
              case ThemeMode.light:
                bloc.add(const SetLightTheme());
              case ThemeMode.dark:
                bloc.add(const SetDarkTheme());
            }
          },
        );
      },
    );
  }
}
