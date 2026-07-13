import 'package:expense_app/features/auth/data/auth_repo.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:get_it/get_it.dart';

import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../data_source/auth_data_source/auth_local_source.dart';
import '../../data_source/auth_data_source/auth_remote_source.dart';
import '../../storage/sqflite_curd.dart';
import 'di_module.dart';

class AuthDiModule implements DIModule {
  final GetIt sl;
  AuthDiModule(this.sl);
  @override
  Future<dynamic> init() async {
    sl.registerLazySingleton(
      () => AuthLocalSource(sqfLiteCurd: sl<SqfLiteCurd>()),
    );
    sl.registerLazySingleton(() => AuthRemoteSource());
    sl.registerLazySingleton(
      () => AuthRepo(
        authRemoteSource: sl<AuthRemoteSource>(),
        authLocalSource: sl<AuthLocalSource>(),
      ),
    );
    sl.registerLazySingleton(() => AuthUseCases(repo: sl<AuthRepo>()));
    sl.registerFactory(() => AuthBloc(useCases: sl<AuthUseCases>()));
  }
}
