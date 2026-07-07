import 'package:expense_app/core/constant/enums.dart';

abstract class AuthStates {}

class LoginInitState extends AuthStates {}

class LoginStatusState extends AuthStates {
  final String message;
  final Status status;

  LoginStatusState({required this.status, this.message = ''});
}

class ObscurePasswordState extends AuthStates {
  bool isObscure;
  ObscurePasswordState({this.isObscure = true});
}

/// Sign Up Screen States
class SignUpInitialState extends AuthStates {}

class SingUpStatusStates extends AuthStates {
  final String message;
  final Status status;
  bool isAgree;
  SingUpStatusStates({
    required this.status,
    this.message = '',
    this.isAgree = false,
  });
}
