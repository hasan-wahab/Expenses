import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:get_it/get_it.dart';

import '../../../features/summary/data/summary_repo.dart';
import '../../../features/summary/domain/usescases/summary_usecases.dart';
import '../../../features/summary/presentation/bloc/summary_bloc.dart';
import '../../data_source/expense_data_source/expense_local_source.dart';
import '../../data_source/expense_data_source/expense_remote_source.dart';
import '../../data_source/properties_data_source/propertis_local_source.dart';

class SummaryDiModule extends DIModule {
  final GetIt sl;
  SummaryDiModule(this.sl);
  @override
  Future<dynamic> init() async {
    sl
      ..registerLazySingleton<SummaryRepo>(
        () => SummaryRepo(
          expenseLocalSource: sl<ExpenseLocalSource>(),
          propertiesLocalSource: sl<PropertiesLocalSource>(),
          expenseRemoteSource: sl<ExpenseRemoteSource>(),
        ),
      )
      ..registerLazySingleton(
        () => SummaryUseCases(summaryRepo: sl<SummaryRepo>()),
      );
    sl.registerFactory(() => SummaryBloc(useCases: sl<SummaryUseCases>()));
  }
}
