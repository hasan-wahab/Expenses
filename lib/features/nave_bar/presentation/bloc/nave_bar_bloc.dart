import 'package:bloc/bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_states.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_events.dart';
import 'package:path/path.dart';

class NaveBarBloc extends Bloc<NaveBarEvents, NaveBarStates> {
  NaveBarBloc() : super(NaveBarStates()) {
    on<NaveBarIndexEvent>(
      (event, emit) => emit(NaveBarStates(index: event.index)),
    );
  }
}
