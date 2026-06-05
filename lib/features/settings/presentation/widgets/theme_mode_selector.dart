import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;

        return SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(Size(0, 44.h)),
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(horizontal: 10.w),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            side: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return BorderSide(
                color: selected
                    ? colorScheme.primary.withValues(alpha: 0.42)
                    : colorScheme.outlineVariant.withValues(alpha: 0.7),
              );
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return selected
                  ? colorScheme.primary.withValues(alpha: 0.12)
                  : colorScheme.surface.withValues(alpha: 0.48);
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return selected ? colorScheme.primary : colorScheme.onSurface;
            }),
          ),
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
