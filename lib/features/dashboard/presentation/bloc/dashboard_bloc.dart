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
  StreamSubscription? subscription;

  DashboardBloc({required this.useCase}) : super(DashboardInitial()) {
    on<GetCardListEvent>(_getPropertyCardEvent);
    on<SyncDataEvent>(_syncPropertyCardEvent);
    on<GetSyncDataEvent>(_getSyncPropertyCardEvent);

    add(SyncDataEvent());
  }

  // FutureOr<void> _addNewPropertyCardEvent(AddNewPropertyCardEvent event,
  //     Emitter<DashboardStates> emit,)
  // async {
  //   try {
  //     /// Initial state of the Dashboard screen
  //     emit(GetPropertyCardState(propertyCardList: [], status: Status.loading));
  //
  //     /// Save Property
  //     await useCase.saveProperty(model: event.model);
  //
  //     /// Get Property
  //     List<DashboardCardEntity> list = await useCase.getPropertyList();
  //
  //     /// Success State
  //     emit(
  //       GetPropertyCardState(propertyCardList: list, status: Status.success),
  //     );
  //   } catch (e) {
  //     /// Error State
  //     GetPropertyCardState(
  //       propertyCardList: [],
  //       status: Status.error,
  //       message: e.toString(),
  //     );
  //   }
  // }

  FutureOr<void> _getPropertyCardEvent(
    GetCardListEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    try {
      /// Initial state of the Dashboard screen
      emit(GetPropertyCardState(propertyCardList: [], status: Status.loading));

      /// Get Property
      List<DashboardCardEntity> list = await useCase.getPropertyList();

      /// Success State
      if (list.isEmpty) {
        emit(
          GetPropertyCardState(
            propertyCardList: [],
            status: Status.error,
            message: 'No Data Found',
          ),
        );
      } else {
        /// Success State
        emit(
          GetPropertyCardState(propertyCardList: list, status: Status.success),
        );
      }
    } catch (e) {
      /// Error State
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
    /// Continuously check for internet connectivity
    subscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (await InternetUtils.isInternetAvailable()) {
        /// Here we sync data from firebase to local storage
        await useCase.syncData();
        if (isClosed) return;

        /// Get Sync Data Event to get data from local storage
        add(GetSyncDataEvent());
      }
    });
  }

  FutureOr<void> _getSyncPropertyCardEvent(
    GetSyncDataEvent event,
    Emitter<DashboardStates> emit,
  ) async {
    try {
      /// Initial state of the Dashboard screen
      List<DashboardCardEntity> list = await useCase.getPropertyList();

      /// Success State
      if (list.isEmpty) {
        emit(
          GetPropertyCardState(
            propertyCardList: [],
            status: Status.error,
            message: 'No Data Found',
          ),
        );
      } else {
        /// Success State
        emit(
          GetPropertyCardState(propertyCardList: list, status: Status.success),
        );
      }
    } catch (e) {
      /// Error State
      GetPropertyCardState(
        propertyCardList: [],
        status: Status.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> close() {
    if (subscription != null) subscription!.cancel();
    return super.close();
  }
}
