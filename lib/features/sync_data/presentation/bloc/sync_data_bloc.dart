import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/sync_data/domain/usescases/sync_data_use_cases.dart';
import 'package:expense_app/features/sync_data/presentation/bloc/sync_data_events.dart';
import 'package:expense_app/features/sync_data/presentation/bloc/sync_data_states.dart';

class SyncDataBloc extends Bloc<SyncDataEvent, SyncDataStates> {
  SyncDataUseCases useCases;
  SyncDataBloc({required this.useCases}) : super(SyncDataLoadingState()) {
    on<SyncDataEvent>(_syncData);
  }

  FutureOr<void> _syncData(
    SyncDataEvent event,
    Emitter<SyncDataStates> emit,
  ) async {
    try {
      emit(SyncDataLoadingState());

      await useCases.syncDataCall();
      await Future.delayed(Duration(seconds: 2));
      emit(SyncDataLoadedState());
    } catch (e) {
      print(e);
    }
  }
}
