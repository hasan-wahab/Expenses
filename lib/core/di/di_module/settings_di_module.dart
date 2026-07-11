import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:get_it/get_it.dart';

import '../../../features/auth/data/local.dart';
import '../../../features/auth/data/remote.dart';
import '../../../features/settings/data/local.dart';
import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../storage/sqflite_curd.dart';

class SettingsDiModule implements DIModule {
  SettingsDiModule(this.sl);
  GetIt sl;
  @override
  Future<void> init() async {
    /// Settings Local Repo
    sl.registerLazySingleton<SettingsLocalRepo>(
      () => SettingsLocalRepo(
        sqfLiteCurd: sl<SqfLiteCurd>(),
        authRemote: sl<AuthRemote>(),
        authLocal: sl<AuthLocal>(),
      ),
    );

    /// Settings Bloc
    sl.registerFactory<SettingsBloc>(
      () => SettingsBloc(localRepo: sl<SettingsLocalRepo>()),
    );
  }
}
