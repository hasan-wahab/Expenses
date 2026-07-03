import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_repo_inter.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_states.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthUseCases useCases;

  AuthBloc({required this.useCases}) : super(LoginInitState()) {
    on<OnPressedLoginEvent>(_onLogin);
    on<ObsecurePasswordEvent>(_isObscurePassword);
    on<LoginWithFingerPrintEvent>(_loginWithFingerPrint);
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

  FutureOr<void> _isObscurePassword(
    ObsecurePasswordEvent event,
    Emitter<AuthStates> emit,
  ) {
    bool isObscure = useCases.obscurePassword(isObscure: event.isObscure);
    emit(ObscurePasswordState(isObscure: isObscure));
  }

  FutureOr<void> _loginWithFingerPrint(
    LoginWithFingerPrintEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(LoginStatusState(status: Status.loading));
      await useCases.loginWithFingerPrint();
      emit(LoginStatusState(status: Status.success, message: 'Login'));
    } catch (e) {
      if (e == LocalAuthExceptionCode.noBiometricsEnrolled) {
        emit(LoginStatusState(status: Status.error, message: 'No_Fingerprint'));
      } else if (e == LocalAuthExceptionCode.userCanceled) {
        emit(
          LoginStatusState(
            status: Status.error,
            message: 'Please touch the fingerprint sensor.',
          ),
        );
      } else {
        emit(
          LoginStatusState(
            status: Status.error,
            message: 'Somethings went wrong!',
          ),
        );
      }
    }
  }
}
