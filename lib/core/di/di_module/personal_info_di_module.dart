import 'package:expense_app/core/data_source/local_image_source/image_source_repo.dart';
import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/core/utils/image_picker.dart';
import 'package:expense_app/features/personal_info/presentation/bloc/personal_info_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../features/personal_info/data/personal_repo.dart';
import '../../../features/personal_info/domain/usecases/personal_usecases.dart';
import '../../data_source/auth_data_source/auth_local_source.dart';
import '../../data_source/auth_data_source/auth_remote_source.dart';

class PersonalInfoDiModule extends DIModule {
  GetIt sl;
  PersonalInfoDiModule(this.sl);
  @override
  Future<void> init() async {
    sl
      ..registerLazySingleton(
        () => PersonalRepo(
          imageSourceRepo: sl<LocalImageSource>(),
          authLocalSource: sl<AuthLocalSource>(),
          authRemoteSource: sl<AuthRemoteSource>(),
        ),
      )
      ..registerLazySingleton(() => PersonalUseCases(personalRepo: sl()));
    sl.registerFactory(
      () => PersonalInfoBloc(useCases: sl<PersonalUseCases>()),
    );
  }
}
