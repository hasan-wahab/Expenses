import 'package:expense_app/core/data_source/expense_data_source/expense_local_source.dart';
import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:get_it/get_it.dart';

import '../../../features/add_expenses/data/expenses_repo.dart';
import '../../../features/add_expenses/domain/usescases/add_expense_usecases.dart';
import '../../../features/add_expenses/presentation/bloc/add_expenses_bloc.dart';
import '../../data_source/expense_data_source/expense_remote_source.dart';
import '../../data_source/properties_data_source/propertis_local_source.dart';
import '../../storage/sqflite_curd.dart';

class AddExpenseDiModule implements DIModule {
  final GetIt sl;
  AddExpenseDiModule(this.sl);

  @override
  Future<dynamic> init() async {
    sl
      ..registerLazySingleton(
        () => ExpenseLocalSource(
          sqfLiteCurd: sl<SqfLiteCurd>(),
          propertiesLocalSource: sl<PropertiesLocalSource>(),
        ),
      )
      ..registerLazySingleton(
        () => ExpenseRemoteSource(sqfLiteCurd: sl<SqfLiteCurd>()),
      )
      ..registerLazySingleton(
        () => ExpensesRepo(
          sqfLiteCurd: sl<SqfLiteCurd>(),
          expenseLocalSource: sl<ExpenseLocalSource>(),
          propertiesLocalSource: sl<PropertiesLocalSource>(),
        ),
      )
      ..registerLazySingleton(
        () => AddExpenseUseCases(expensesRepo: sl<ExpensesRepo>()),
      );
    sl.registerFactory(
      () => AddExpensesBloc(useCases: sl<AddExpenseUseCases>()),
    );
  }
}
