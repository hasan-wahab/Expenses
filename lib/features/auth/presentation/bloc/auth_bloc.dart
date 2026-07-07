import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_states.dart';
import 'package:expense_app/features/settings/data/local.dart';
import 'package:local_auth/local_auth.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthUseCases useCases;
  SettingsLocalRepo settingsLocalRepo;

  AuthBloc({required this.useCases, required this.settingsLocalRepo})
    : super(LoginInitState()) {
    on<OnPressedLoginEvent>(_onLogin);
    on<ObsecurePasswordEvent>(_isObscurePassword);
    on<LoginWithFingerPrintEvent>(_loginWithFingerPrint);
    on<OnPressedCreateEvent>(_createUser);
    on<OnAgreeEvent>(_isAgree);
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
      bool isAdded = await settingsLocalRepo.getFingerPrint();
      if (!isAdded) {
        emit(
          LoginStatusState(
            status: Status.error,
            message: 'Login first, then enable fingerprint in Settings.',
          ),
        );
      } else {
        await useCases.loginWithFingerPrint();
        emit(LoginStatusState(status: Status.success, message: 'Login'));
      }
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

  FutureOr<void> _createUser(
    OnPressedCreateEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(SingUpStatusStates(status: Status.loading));
      await useCases.createUser(
        name: event.username,
        email: event.email,
        password: event.password,
        cPassword: event.cPassword,
        isAgree: event.isAgree,
      );
      emit(
        SingUpStatusStates(
          status: Status.success,
          message: 'User Created with ${event.email}',
        ),
      );
    } catch (e) {
      emit(SingUpStatusStates(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _isAgree(OnAgreeEvent event, Emitter<AuthStates> emit) {
    emit(SingUpStatusStates(status: Status.initial, isAgree: event.isAgree));
  }
}
