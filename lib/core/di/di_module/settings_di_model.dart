import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/features/settings/data/local.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../storage/sqflite_curd.dart';

class SettingsDiModel implements DIModule {
  final GetIt sl;
  SettingsDiModel(this.sl);
  @override
  Future<dynamic> init() async {
    sl.registerLazySingleton(
      () => SettingsLocalRepo(sqfLiteCurd: sl<SqfLiteCurd>()),
    );
    sl.registerFactory(() => SettingsBloc(localRepo: sl<SettingsLocalRepo>()));
  }
}
