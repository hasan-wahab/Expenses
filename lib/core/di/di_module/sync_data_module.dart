import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/features/sync_data/domain/usescases/sync_data_use_cases.dart';
import 'package:get_it/get_it.dart';

import '../../../features/sync_data/data/sync_repo.dart';
import '../../../features/sync_data/presentation/bloc/sync_data_bloc.dart';
import '../../data_source/properties_data_source/properties_remote_source.dart';
import '../../storage/sqflite_curd.dart';
import 'di_module.dart';

class SyncDataDiModule implements DIModule {
  final GetIt sl;
  SyncDataDiModule(this.sl);
  @override
  Future<dynamic> init() async {
    sl
      ..registerLazySingleton(() => PropertiesRemoteSource())
      ..registerLazySingleton(
        () => PropertiesLocalSource(sqfLiteCurd: sl<SqfLiteCurd>()),
      )
      ..registerLazySingleton<SyncRepo>(
        () => SyncRepo(
          remoteSource: sl<PropertiesRemoteSource>(),
          localSource: sl<PropertiesLocalSource>(),
        ),
      )
      ..registerLazySingleton(() => SyncDataUseCases(syncRepo: sl<SyncRepo>()));

    sl.registerFactory(() => SyncDataBloc(useCases: sl<SyncDataUseCases>()));
  }
}
