import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/add_expenses/data/local.dart';
import 'package:expense_app/features/add_expenses/domain/usescases/add_expense_usecases.dart';
import 'package:expense_app/features/add_expenses/presentation/bloc/add_expenses_bloc.dart';
import 'package:get_it/get_it.dart';

class AddExpenseDiModule implements DIModule {
  final GetIt sl;
  AddExpenseDiModule({required this.sl});
  @override
  Future<void> init() async {
    sl
      ..registerLazySingleton(
        () => AddExpensesLocal(sqfLiteCurd: sl<SqfLiteCurd>()),
      )
      ..registerLazySingleton(
        () => AddExpenseUseCases(addExpensesLocal: sl<AddExpensesLocal>()),
      );

    sl.registerFactory(
      () => AddExpensesBloc(useCases: sl<AddExpenseUseCases>()),
    );
  }
}
