import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  const ThemeState({this.themeMode = ThemeMode.dark});

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}
