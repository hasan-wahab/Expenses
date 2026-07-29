import 'dart:async';
import 'dart:math';

import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/enums.dart';
import '../../domain/entitity/summary_entity_model.dart';
import '../../domain/usescases/summary_usecases.dart';
import 'summary_events.dart';
import 'summary_states.dart';

class SummaryBloc extends Bloc<SummaryEvents, SummaryStates> {
  SummaryUseCases useCases;
  SummaryBloc({required this.useCases}) : super(SummaryInitialState()) {
    on<OnGetSummaryDataEvent>(_getSummaryData);
  }

  FutureOr<void> _getSummaryData(
    OnGetSummaryDataEvent event,
    Emitter<SummaryStates> emit,
  ) async {
    try {
      emit(GetSummaryDataState(status: Status.loading, expenses: []));

      SummaryEntityModel summaryEntityModel = await useCases.getSummaryData(
        propertyCardId: event.propertyCardId,
      );
      List<ExpenseEntity> expenses = await useCases.getAllExpenses(
        propertyCardId: event.propertyCardId,
      );
      emit(
        GetSummaryDataState(
          status: Status.success,
          expenses: expenses,
          summaryEntityModel: summaryEntityModel,
        ),
      );
    } catch (e) {
      emit(
        GetSummaryDataState(
          expenses: [],
          summaryEntityModel: SummaryEntityModel(
            totalExpense: 0,
            categoryBreakdown: [],

            expenses: [],
          ),
          status: Status.error,
          message: e.toString(),
        ),
      );
    }
  }
}
