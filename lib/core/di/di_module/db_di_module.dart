import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:get_it/get_it.dart';

import '../../storage/sqflite.dart';
import '../../storage/sqflite_curd.dart';

class DbDiModule implements DIModule {
  DbDiModule(this.sl);
  GetIt sl;
  @override
  Future<void> init() async {
    sl
      /// DB Helper
      ..registerLazySingleton<DBHelper>(() => DBHelper())
      /// SqFLite Cured
      ..registerLazySingleton<SqfLiteCurd>(
        () => SqfLiteCurd(dB: sl<DBHelper>()),
      );
  }
}
