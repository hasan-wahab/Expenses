import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/dashboard/domain/usescases/dashboard_use_case.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_events.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constant/enums.dart';
import '../../domain/entitity/dashboard_card_entity.dart';
import 'dashboard_states.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardStates> {
  DashboardUseCase useCase;
  StreamSubscription? subscription;

  DashboardBloc({required this.useCase}) : super(DashboardInitial()) {
    on<GetCardListEvent>(_getPropertyCardEvent);
    on<RefreshPropertyListEvent>(_refreshPropertyListEvent);
  }

  FutureOr<void> _getPropertyCardEvent(
    GetCardListEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    try {
      /// Initial state of the Dashboard screen
      emit(GetPropertyCardState(propertyCardList: [], status: Status.loading));
      await useCase.syncData();

      /// Get Property
      List<DashboardCardEntity> list = await useCase.getPropertyList();

      /// Success State
      if (list.isEmpty) {
        if (kDebugMode) {
          print('No data found');
        }
        emit(
          GetPropertyCardState(propertyCardList: list, status: Status.success),
        );
      } else {
        /// Success State
        emit(
          GetPropertyCardState(propertyCardList: list, status: Status.success),
        );
      }
    } catch (e) {
      /// Error State
      emit(
        GetPropertyCardState(
          propertyCardList: [],
          status: Status.error,
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _refreshPropertyListEvent(
    RefreshPropertyListEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    try {
      emit(GetPropertyCardState(propertyCardList: [], status: Status.loading));
      await useCase.syncData();

      /// Initial state of the Dashboard screen
      List<DashboardCardEntity> list = await useCase.getPropertyList();

      /// Success State
      if (list.isEmpty) {
        if (kDebugMode) {
          print('No data found');
        }
        emit(
          GetPropertyCardState(propertyCardList: list, status: Status.success),
        );
      } else {
        /// Success State
        emit(
          GetPropertyCardState(propertyCardList: list, status: Status.success),
        );
      }
    } catch (e) {

      /// Error State
      emit(
        GetPropertyCardState(
          propertyCardList: [],
          status: Status.error,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    if (subscription != null) subscription!.cancel();
    return super.close();
  }
}
