import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/dashboard/domain/usescases/dashboard_use_case.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_events.dart';

import '../../../../core/constant/enums.dart';
import '../../domain/entitity/dashboard_card_entity.dart';
import 'dashboard_states.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardStates> {
  DashboardUseCase useCase;
  late StreamSubscription subscription;
  DashboardBloc({required this.useCase}) : super(DashboardInitial()) {
    on<AddNewPropertyCardEvent>(_addNewPropertyCardEvent);
    on<GetCardListEvent>(_getPropertyCardEvent);
    on<SyncDataEvent>(_syncPropertyCardEvent);
    on<GetSyncDataEvent>(_getSyncPropertyCardEvent);
    add(SyncDataEvent());
  }

  FutureOr<void> _addNewPropertyCardEvent(
    AddNewPropertyCardEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    try {
      emit(GetPropertyCardState(propertyCardList: [], status: Status.loading));
      await useCase.saveProperty(model: event.model);
      List<DashboardCardEntity> list = await useCase.getPropertyList();
      emit(
        GetPropertyCardState(propertyCardList: list, status: Status.success),
      );
    } catch (e) {
      GetPropertyCardState(
        propertyCardList: [],
        status: Status.error,
        message: e.toString(),
      );
    }
  }

  FutureOr<void> _getPropertyCardEvent(
    GetCardListEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    try {
      emit(GetPropertyCardState(propertyCardList: [], status: Status.loading));

      List<DashboardCardEntity> list = await useCase.getPropertyList();
      if (list.isEmpty) {
        emit(
          GetPropertyCardState(
            propertyCardList: [],
            status: Status.error,
            message: 'No Data Found',
          ),
        );
      } else {
        emit(
          GetPropertyCardState(propertyCardList: list, status: Status.success),
        );
      }
    } catch (e) {
      GetPropertyCardState(
        propertyCardList: [],
        status: Status.error,
        message: e.toString(),
      );
    }
  }

  FutureOr<void> _syncPropertyCardEvent(
    SyncDataEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    subscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (await InternetUtils.isInternetAvailable()) {
        await useCase.syncData();
        if (isClosed) return;
        add(GetSyncDataEvent());
      }
    });
  }

  FutureOr<void> _getSyncPropertyCardEvent(
    GetSyncDataEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    try {
      List<DashboardCardEntity> list = await useCase.getPropertyList();
      if (list.isEmpty) {
        emit(
          GetPropertyCardState(
            propertyCardList: [],
            status: Status.error,
            message: 'No Data Found',
          ),
        );
      } else {
        emit(
          GetPropertyCardState(propertyCardList: list, status: Status.success),
        );
      }
    } catch (e) {
      GetPropertyCardState(
        propertyCardList: [],
        status: Status.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
