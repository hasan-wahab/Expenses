import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/sync_data/domain/usescases/sync_data_use_cases.dart';
import 'package:expense_app/features/sync_data/presentation/bloc/sync_data_events.dart';
import 'package:expense_app/features/sync_data/presentation/bloc/sync_data_states.dart';

class SyncDataBloc extends Bloc<SyncDataEvent, SyncDataStates> {
  SyncDataUseCases useCases;
  SyncDataBloc({required this.useCases})
    : super(SyncDataLoadingState(progress: 0)) {
    on<SyncDataEvent>(_syncData);
  }

  FutureOr<void> _syncData(
    SyncDataEvent event,
    Emitter<SyncDataStates> emit,
  ) async {
    try {
      emit(SyncDataLoadingState(progress: 0));
      for (int i = 0; i <= 90; i++) {
        await Future.delayed(Duration(milliseconds: 2));
        emit(SyncDataLoadingState(progress: i.toDouble()));
      }
      if (event.isFingerPrint == true) {
        unawaited(useCases.syncDataCall());
        await Future.delayed(Duration(milliseconds: 3));
      } else {
        await useCases.syncDataCall();
      }

      await Future.delayed(Duration(milliseconds: 200));
      emit(SyncDataLoadedState());
    } catch (e) {
      print(e);
    }
  }
}
