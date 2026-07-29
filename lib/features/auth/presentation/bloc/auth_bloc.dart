import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/auth/domain/entitity/auth_entity.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_states.dart';
import 'package:expense_app/features/settings/data/local.dart';
import 'package:local_auth/local_auth.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final AuthUseCases useCases;
  AuthBloc({required this.useCases}) : super(LoginInitState()) {
    on<OnPressedLoginEvent>(_login);

    on<OnPressedCreateEvent>(_create);
    on<OnAgreeEvent>(_onAgreeEvent);
    on<LoginWithFingerPrintEvent>(_loginWithFingerPrint);
    on<ObsecurePasswordEvent>(_isObscurePassword);
  }

  FutureOr<void> _login(
    OnPressedLoginEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(LoginStatusState(status: Status.loading));
      if (await InternetUtils.hasInternetAccess()) {
        await useCases.loginCall(email: event.email, password: event.password);
        emit(LoginStatusState(status: Status.success));
      } else {
        emit(
          LoginStatusState(
            status: Status.error,
            message: 'No internet connection!',
          ),
        );
      }
    } catch (e) {
      emit(LoginStatusState(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _create(
    OnPressedCreateEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(SignUpInitialState());
      if (event.username.isEmpty &&
          event.email.isEmpty &&
          event.password.isEmpty) {
        emit(
          SingUpStatusStates(
            status: Status.error,
            message: 'All fields are required!',
          ),
        );
      } else if (event.password != event.cPassword) {
        emit(
          SingUpStatusStates(
            status: Status.error,
            message: 'Password does not match!',
          ),
        );
      } else if (!event.isAgree) {
        emit(
          SingUpStatusStates(
            status: Status.error,
            message: 'Please agree to the terms and conditions!',
          ),
        );
      } else {
        emit(SingUpStatusStates(status: Status.loading));
        if (await InternetUtils.hasInternetAccess()) {
          await useCases.createCall(
            entityModel: AuthEntity(
              name: event.username,
              email: event.email,
              password: event.password,
            ),
          );
          emit(
            SingUpStatusStates(
              status: Status.success,
              message: 'User created successfully!',
            ),
          );
        } else {
          emit(
            SingUpStatusStates(
              status: Status.error,
              message: 'No internet connection!',
            ),
          );
        }
      }
    } catch (e) {
      emit(SingUpStatusStates(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _onAgreeEvent(
    OnAgreeEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(SingUpStatusStates(isAgree: event.isAgree, status: Status.initial));
  }

  FutureOr<void> _isObscurePassword(
    ObsecurePasswordEvent event,
    Emitter<AuthStates> emit,
  ) {
    bool isObscure = useCases.obscurePasswordCall(isObscure: event.isObscure);
    emit(ObscurePasswordState(isObscure: isObscure));
  }

  FutureOr<void> _loginWithFingerPrint(
    LoginWithFingerPrintEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(LoginStatusState(status: Status.loading));
      bool isFingerPrintAdded = await useCases.getFingerPrintCall();
      print(isFingerPrintAdded);
      if (isFingerPrintAdded) {
        await useCases.loginWithFingerPrintCall();
        emit(
          LoginStatusState(
            status: Status.success,
            message: 'Login with fingerprint',
          ),
        );
      } else {
        emit(
          LoginStatusState(
            status: Status.error,
            message: 'Login first, then enable fingerprint in Settings.',
          ),
        );
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
}
