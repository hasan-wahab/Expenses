import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:get_it/get_it.dart';

import '../../../features/add_property/data/images/image_source_repo.dart';
import '../../../features/add_property/domain/usescases/add_property_usecases.dart';
import '../../../features/add_property/presentation/bloc/add_property_bloc.dart';
import '../../../features/dashboard/data/local.dart';
import '../../../features/dashboard/data/remote.dart';
import '../get_it.dart';

class AddPropertyDiModule implements DIModule {
  GetIt sl;
  AddPropertyDiModule(this.sl);
  @override
  Future<void> init() async {
    sl.registerLazySingleton<AddPropertyUseCases>(
      () => AddPropertyUseCases(
        imageSourceRepo: sl<ImageSourceRepo>(),
        dashboardRepoInter: sl<DashboardRemote>(),
        local: sl<DashboardLocal>(),
      ),
    );
    sl.registerFactory<AddPropertyBloc>(
      () => AddPropertyBloc(useCases: sl<AddPropertyUseCases>()),
    );
  }
}
