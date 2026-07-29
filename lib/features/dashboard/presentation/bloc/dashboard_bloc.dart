import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/dashboard/domain/usescases/dashboard_use_case.dart';

import '../../../add_expenses/data/models/expense_model.dart';
import 'dashboard_events.dart';
import 'dashboard_states.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardStates> {
  DashboardUseCase useCase;
  DashboardBloc({required this.useCase}) : super(DashboardInitial()) {
    on<GetPropertiesEvent>(_getProperties);
    on<DeletePropertyEvent>(_deleteProperty);
  }

  FutureOr<void> _getProperties(
    GetPropertiesEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    try {
      emit(GetProperties(propertyList: [], status: Status.loading));
      List<DashboardCardEntity> model = await useCase.getPropertiesListCall();

      emit(GetProperties(propertyList: model, status: Status.success));
    } catch (e) {
      emit(
        GetProperties(
          propertyList: [],
          status: Status.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _deleteProperty(
    DeletePropertyEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    try {
      emit(GetProperties(propertyList: [], status: Status.loading));
      await useCase.deletePropertyCall(
        model: PropertyModel.fromEntity(event.propertyEntity),
      );
      List<DashboardCardEntity> list = await useCase.getPropertiesListCall();
      emit(GetProperties(propertyList: list, status: Status.success));
    } catch (e) {
      emit(
        GetProperties(
          propertyList: [],
          status: Status.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
