import 'package:expense_app/features/auth/data/remote.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_repo_inter.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final  sl = GetIt.instance;

void getITSetup() {
  sl
    ..registerLazySingleton<AuthRepoInter>(() => AuthRemote())
    ..registerLazySingleton<AuthUseCases>(() => AuthUseCases(authRepoInter: sl<AuthRepoInter>()));
    sl.registerFactory<AuthBloc>(() => AuthBloc(useCases: sl<AuthUseCases>()));
}
