import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/add_expenses/data/local.dart';
import 'package:expense_app/features/add_expenses/domain/usescases/add_expense_usecases.dart';
import 'package:expense_app/features/add_expenses/presentation/bloc/add_expenses_event.dart';
import 'package:expense_app/features/add_property/presentation/bloc/add_property_event.dart' hide AddNewCategoryEvent;

import 'add_expenses_states.dart';

class AddExpensesBloc extends Bloc<AddExpensesEvent, AddExpensesStates> {
  final AddExpenseUseCases useCases;
  AddExpensesBloc({required this.useCases}) : super(AddExpensesInitial()) {
    on<AddNewCategoryEvent>(_addNewCategoryEvent);
  }

  FutureOr<void> _addNewCategoryEvent(
    AddNewCategoryEvent event,
    Emitter<AddExpensesStates> emit,
  ) async {
    await useCases.addCategoryCall(categoryName: event.categoryName);
    final result = await useCases.getCategoriesCall(
      categoryName: event.categoryName,
    );
    print(result);
  }
}
