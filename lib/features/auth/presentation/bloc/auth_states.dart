import 'package:expense_app/core/constant/enums.dart';

abstract class AuthStates {}

class LoginInitState extends AuthStates {}

class LoginStatusState extends AuthStates {
  final String message;
  final Status status;

  LoginStatusState({required this.status, this.message = ''});
}
