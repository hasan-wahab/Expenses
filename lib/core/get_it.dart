import 'package:expense_app/core/storage/sqflite.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/auth/data/local.dart';
import 'package:expense_app/features/auth/data/remote.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_repo_inter.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_app/features/dashboard/data/local.dart';
import 'package:expense_app/features/dashboard/data/remote.dart';
import 'package:expense_app/features/dashboard/domain/repos_inter/dashboard_repo_inter.dart';
import 'package:expense_app/features/dashboard/domain/usescases/dashboard_use_case.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/settings/data/local.dart';
import 'package:expense_app/features/settings/domain/repos_inter/settings_interface.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void getITSetup() {
  sl
    /// DB Helper
    ..registerLazySingleton<DBHelper>(() => DBHelper())
    /// SqFLite Cured
    ..registerLazySingleton<SqfLiteCurd>(() => SqfLiteCurd(dB: sl<DBHelper>()))
    /// Auth Remote repo
    ..registerLazySingleton<AuthLocal>(
      () => AuthLocal(sqfLiteCurd: sl<SqfLiteCurd>()),
    )
    /// Auth Remote
    ..registerLazySingleton<AuthRemote>(
      () => AuthRemote(authLocal: sl<AuthLocal>()),
    )
    ..registerLazySingleton<AuthRepoInter>(() => sl<AuthRemote>())
    /// Settings Local Repo
    ..registerLazySingleton<SettingsLocalRepo>(
      () => SettingsLocalRepo(
        sqfLiteCurd: sl<SqfLiteCurd>(),
        authRemote: sl<AuthRemote>(),
        authLocal: sl<AuthLocal>(),
      ),
    )
    /// Auth use cases
    ..registerLazySingleton<AuthUseCases>(
      () => AuthUseCases(authRepoInter: sl<AuthRepoInter>()),
    );

  /// Dashboard Remote
  sl
    ..registerLazySingleton<DashboardRemote>(() => DashboardRemote())
    /// Dashboard Remote
    ..registerLazySingleton<DashboardRepoInter>(() => sl<DashboardRemote>())
    /// Dashboard Local
    ..registerLazySingleton<DashboardLocal>(
      () => DashboardLocal(sqfLiteCurd: sl<SqfLiteCurd>()),
    )
    /// Dashboard Use Case
    ..registerLazySingleton<DashboardUseCase>(
      () => DashboardUseCase(
        dashboardRepoInter: sl<DashboardRepoInter>(),
        local: sl<DashboardLocal>(),
      ),
    );

  /// Dashboard Bloc
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(useCase: sl<DashboardUseCase>()),
  );

  /// Auth Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      useCases: sl<AuthUseCases>(),
      settingsLocalRepo: sl<SettingsLocalRepo>(),
    ),
  );

  /// Nave Bar Bloc
  sl.registerFactory(() => NaveBarBloc());

  /// Settings Bloc
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(localRepo: sl<SettingsLocalRepo>()),
  );
}
