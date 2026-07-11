import 'package:get_it/get_it.dart';

import '../../../features/auth/data/local.dart';
import '../../../features/auth/data/remote.dart';
import '../../../features/auth/domain/repos_inter/auth_repo_inter.dart';

import '../../../features/auth/domain/usescases/auth_usecases.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/settings/data/local.dart';
import '../../storage/sqflite_curd.dart';
import 'di_module.dart';

class AuthDIModule implements DIModule {
  AuthDIModule(this.sl);
  GetIt sl;
  @override
  Future<void> init() async {
    /// Auth Remote repo
    sl
      ..registerLazySingleton<AuthLocal>(
        () => AuthLocal(sqfLiteCurd: sl<SqfLiteCurd>()),
      )
      /// Auth Remote
      ..registerLazySingleton<AuthRemote>(
        () => AuthRemote(authLocal: sl<AuthLocal>()),
      )
      ..registerLazySingleton<AuthRepoInter>(() => sl<AuthRemote>())
      /// Auth use cases
      ..registerLazySingleton<AuthUseCases>(
        () => AuthUseCases(authRepoInter: sl<AuthRepoInter>()),
      );

    /// Auth Bloc
    sl.registerFactory<AuthBloc>(
      () => AuthBloc(
        useCases: sl<AuthUseCases>(),
        settingsLocalRepo: sl<SettingsLocalRepo>(),
      ),
    );
  }
}
