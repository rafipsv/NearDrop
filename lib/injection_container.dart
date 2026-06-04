import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/shared_preferences_theme_storage.dart';
import 'core/theme/theme_storage.dart';
import 'features/transfer/data/datasources/file_picker_data_source.dart';
import 'features/transfer/data/datasources/file_picker_data_source_impl.dart';
import 'features/transfer/data/repositories/file_selection_repository_impl.dart';
import 'features/transfer/domain/repositories/file_selection_repository.dart';
import 'features/transfer/domain/usecases/pick_files_usecase.dart';
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
    ..registerLazySingleton<FilePickerDataSource>(
      () => const FilePickerDataSourceImpl(),
    )
    ..registerLazySingleton<FileSelectionRepository>(
      () => FileSelectionRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => PickFilesUseCase(sl()))
    ..registerFactory(() => ThemeBloc(sl())..add(const LoadTheme()))
    ..registerFactory(() => DiscoveryBloc())
    ..registerFactory(() => TransferBloc(sl()));
}
