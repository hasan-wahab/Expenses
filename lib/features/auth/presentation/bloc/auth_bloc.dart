import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/auth/domain/entitity/auth_entity.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_states.dart';
import 'package:local_auth/local_auth.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final AuthUseCases useCases;
  AuthBloc({required this.useCases}) : super(LoginInitState()) {
    on<OnPressedLoginEvent>(_login);
    on<OnPressedCreateEvent>(_create);
    on<OnAgreeEvent>(_onAgreeEvent);
    on<LoginWithFingerPrintEvent>(_loginWithFingerPrint);
    on<ObsecurePasswordEvent>(_isObscurePassword);
    on<SendEmailVerificationEvent>(_sendEmailVerification);
    on<CheckEmailVerifiedEvent>(_checkEmailVerified);
  }

  FutureOr<void> _login(
    OnPressedLoginEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(LoginStatusState(status: Status.loading));
      if (await InternetUtils.hasInternetAccess()) {
        await useCases.loginCall(email: event.email, password: event.password);
        /// EMAIL VERIFICATION DISABLED — uncomment to require verified email again.
        // final verified = await useCases.isEmailVerifiedCall();
        // if (!verified) {
        //   /// Do not auto-send here — avoids Firebase too-many-requests.
        //   /// User can tap Resend on VerifyEmailScreen.
        //   emit(
        //     LoginStatusState(
        //       status: Status.success,
        //       message: 'email_not_verified',
        //     ),
        //   );
        //   return;
        // }
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
          /// EMAIL VERIFICATION DISABLED — was: message: 'email_not_verified'
          // emit(
          //   SingUpStatusStates(
          //     status: Status.success,
          //     message: 'email_not_verified',
          //   ),
          // );
          emit(SingUpStatusStates(status: Status.success));
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
        emit(LoginStatusState(status: Status.error, message: e.toString()));
      }
    }
  }

  FutureOr<void> _sendEmailVerification(
    SendEmailVerificationEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(EmailVerificationState(status: Status.loading));
      if (!await InternetUtils.hasInternetAccess()) {
        emit(
          EmailVerificationState(
            status: Status.error,
            message: 'No internet connection!',
          ),
        );
        return;
      }
      await useCases.sendEmailVerificationCall();
      emit(
        EmailVerificationState(
          status: Status.success,
          message:
              'Verification email sent. Check Inbox — if not there, check Spam / Junk.',
        ),
      );
    } catch (e) {
      final message = e.toString();
      if (message.contains('too-many-requests')) {
        emit(
          EmailVerificationState(
            status: Status.error,
            message:
                'Firebase blocked this device temporarily. Wait 15–60 min, then tap Resend. Check Spam too.',
          ),
        );
        return;
      }
      emit(EmailVerificationState(status: Status.error, message: message));
    }
  }

  FutureOr<void> _checkEmailVerified(
    CheckEmailVerifiedEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(EmailVerificationState(status: Status.loading));
      if (!await InternetUtils.hasInternetAccess()) {
        emit(
          EmailVerificationState(
            status: Status.error,
            message: 'No internet connection!',
          ),
        );
        return;
      }
      final verified = await useCases.reloadAndCheckEmailVerifiedCall();
      if (verified) {
        emit(
          EmailVerificationState(
            status: Status.success,
            isVerified: true,
            message: 'Email verified successfully',
          ),
        );
      } else {
        emit(
          EmailVerificationState(
            status: Status.error,
            message: 'Email not verified yet. Open the link in your inbox.',
          ),
        );
      }
    } catch (e) {
      emit(EmailVerificationState(status: Status.error, message: e.toString()));
    }
  }
}
