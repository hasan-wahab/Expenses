import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_repo_inter.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_states.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthUseCases useCases;

  AuthBloc({required this.useCases}) : super(LoginInitState()) {
    on<OnPressedLoginEvent>(_onLogin);
  }

  FutureOr<void> _onLogin(
    OnPressedLoginEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(LoginStatusState(status: Status.loading));
      await useCases.userLogin(email: event.email, password: event.password);

      emit(
        LoginStatusState(
          status: Status.success,
          message: 'User Successfully Login.',
        ),
      );
    } catch (e) {
      emit(LoginStatusState(status: Status.error, message: e.toString()));
    }
  }
}
