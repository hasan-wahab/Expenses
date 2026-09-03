import 'package:bloc/bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_states.dart';

class NaveBarBloc extends Bloc<NaveBarEvents, NaveBarStates> {
  NaveBarBloc() : super(NaveBarStates()) {
    on<NaveBarIndexEvent>(
      (event, emit) => emit(state.copyWith(index: event.index)),
    );
    on<NaveBarRefreshHomeEvent>(
      (event, emit) => emit(
        state.copyWith(
          index: 0,
          homeRefreshKey: state.homeRefreshKey + 1,
        ),
      ),
    );
    on<NaveBarSyncHomeEvent>((event, emit) {
      emit(state.copyWith(homeRefreshKey: state.homeRefreshKey + 1));
    });
  }
}
