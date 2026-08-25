import 'package:expense_app/core/data_source/auth_data_source/auth_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/properties_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/features/share_property/data/share_repo.dart';
import 'package:expense_app/features/share_property/domain/share_property_use_cases.dart';
import 'package:expense_app/features/share_property/presentation/bloc/share_property_bloc.dart';
import 'package:get_it/get_it.dart';

class SharePropertyDiModule implements DIModule {
  final GetIt sl;
  SharePropertyDiModule(this.sl);

  @override
  Future<dynamic> init() async {
    sl
      ..registerLazySingleton(
        () => ShareRepo(
          remoteSource: sl<PropertiesRemoteSource>(),
          localSource: sl<PropertiesLocalSource>(),
        ),
      )
      ..registerLazySingleton(
        () => SharePropertyUseCases(
          shareRepo: sl<ShareRepo>(),
          authRemoteSource: sl<AuthRemoteSource>(),
        ),
      );
    sl.registerFactory(
      () => SharePropertyBloc(useCases: sl<SharePropertyUseCases>()),
    );
  }
}
