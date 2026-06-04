import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_storage.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(this._themeStorage) : super(const ThemeState()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<SetLightTheme>((event, emit) => _setThemeMode(ThemeMode.light, emit));
    on<SetDarkTheme>((event, emit) => _setThemeMode(ThemeMode.dark, emit));
    on<SetSystemTheme>((event, emit) => _setThemeMode(ThemeMode.system, emit));
  }

  final ThemeStorage _themeStorage;

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    emit(ThemeState(themeMode: await _themeStorage.loadThemeMode()));
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final nextMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await _setThemeMode(nextMode, emit);
  }

  Future<void> _setThemeMode(ThemeMode mode, Emitter<ThemeState> emit) async {
    await _themeStorage.saveThemeMode(mode);
    emit(ThemeState(themeMode: mode));
  }
}
