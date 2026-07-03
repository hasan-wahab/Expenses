abstract class AuthEvents {}

class OnPressedLoginEvent extends AuthEvents {
  final String email;
  final String password;

  OnPressedLoginEvent({required this.email, required this.password});
}

class ObsecurePasswordEvent extends AuthEvents {
  bool isObscure;
  ObsecurePasswordEvent({required this.isObscure});
}

class LoginWithFingerPrintEvent extends AuthEvents {}
