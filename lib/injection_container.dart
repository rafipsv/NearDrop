import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/shared_preferences_theme_storage.dart';
import 'core/theme/theme_storage.dart';
import 'features/discovery/presentation/bloc/discovery_bloc.dart';
import 'features/settings/presentation/bloc/theme_bloc.dart';
import 'features/settings/presentation/bloc/theme_event.dart';
import 'features/transfer/presentation/bloc/transfer_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final preferences = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton<SharedPreferences>(() => preferences)
    ..registerLazySingleton<ThemeStorage>(
      () => SharedPreferencesThemeStorage(sl()),
    )
    ..registerFactory(() => ThemeBloc(sl())..add(const LoadTheme()))
    ..registerFactory(() => DiscoveryBloc())
    ..registerFactory(() => TransferBloc());
}
