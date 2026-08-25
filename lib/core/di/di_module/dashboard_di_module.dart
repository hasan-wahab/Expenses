import 'package:expense_app/core/data_source/properties_data_source/properties_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/features/dashboard/data/property_repo.dart';
import 'package:get_it/get_it.dart';

import '../../../features/dashboard/domain/usescases/dashboard_use_case.dart';
import '../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../data_source/expense_data_source/expense_local_source.dart';

class DashboardDiModule extends DIModule {
  final GetIt sl;
  DashboardDiModule(this.sl);
  @override
  Future<dynamic> init() async {
    sl
      ..registerLazySingleton<PropertyRepo>(
        () => PropertyRepo(
          propertiesLocalSource: sl<PropertiesLocalSource>(),
          expenseLocalSource: sl<ExpenseLocalSource>(),
          propertiesRemoteSource: sl<PropertiesRemoteSource>(),
        ),
      )
      ..registerLazySingleton<DashboardUseCase>(
        () => DashboardUseCase(propertyRepo: sl<PropertyRepo>()),
      );

    sl.registerFactory<DashboardBloc>(
      () => DashboardBloc(useCase: sl<DashboardUseCase>()),
    );
  }
}
