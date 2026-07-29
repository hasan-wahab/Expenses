import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/features/export_pdf/domain/usescases/export_to_pdf_usecases.dart';
import 'package:get_it/get_it.dart';

import '../../../features/export_pdf/data/export_repo.dart';
import '../../../features/export_pdf/presentation/bloc/export_to_pdf_bloc.dart';
import '../../data_source/expense_data_source/expense_local_source.dart';
import '../../data_source/properties_data_source/propertis_local_source.dart';

class ExportToPdfDiModule extends DIModule {
  GetIt sl;
  ExportToPdfDiModule(this.sl);

  @override
  Future<dynamic> init() async {
    sl.registerLazySingleton(
      () => ExportRepo(
        expenseLocalSource: sl<ExpenseLocalSource>(),
        propertiesLocalSource: sl<PropertiesLocalSource>(),
      ),
    );
    sl.registerLazySingleton(
      () => ExportToPdfUseCases(exportRepo: sl<ExportRepo>()),
    );
    sl.registerFactory<ExportToPdfBloc>(
      () => ExportToPdfBloc(useCases: sl<ExportToPdfUseCases>()),
    );
  }
}
