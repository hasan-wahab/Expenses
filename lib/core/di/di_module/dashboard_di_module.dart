import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:get_it/get_it.dart';

import '../../../features/auth/data/local.dart';
import '../../../features/auth/data/remote.dart';
import '../../../features/dashboard/data/local.dart';
import '../../../features/dashboard/data/remote.dart';
import '../../../features/dashboard/domain/repos_inter/dashboard_repo_inter.dart';
import '../../../features/dashboard/domain/usescases/dashboard_use_case.dart';
import '../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../storage/sqflite_curd.dart';

class DashboardDiModule implements DIModule{
  DashboardDiModule(this.sl);
  GetIt sl;
  @override
  Future<void> init() async{
    /// Dashboard Remote
    sl
      ..registerLazySingleton<DashboardRemote>(
            () => DashboardRemote(authRemote: sl<AuthRemote>()),
      )
    /// Dashboard Remote
      ..registerLazySingleton<DashboardRepoInter>(() => sl<DashboardRemote>())
    /// Dashboard Local
      ..registerLazySingleton<DashboardLocal>(
            () => DashboardLocal(
          sqfLiteCurd: sl<SqfLiteCurd>(),
          local: sl<AuthLocal>(),
        ),
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
  }
}