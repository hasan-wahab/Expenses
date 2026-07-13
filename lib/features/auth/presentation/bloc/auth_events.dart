abstract class AuthEvents {}

class OnPressedLoginEvent extends AuthEvents {
  final String email;
  final String password;

  OnPressedLoginEvent({required this.email, required this.password});
}

class OnPressedCreateEvent extends OnPressedLoginEvent {
  final String username;
  bool isAgree;
  final String cPassword;

  OnPressedCreateEvent({
    this.username = '',
    required super.email,
    required super.password,
    required this.cPassword,
    required this.isAgree,
  });
}

class ObsecurePasswordEvent extends AuthEvents {
  bool isObscure;
  ObsecurePasswordEvent({required this.isObscure});
}

class LoginWithFingerPrintEvent extends AuthEvents {}

class OnAgreeEvent extends AuthEvents {
  bool isAgree;
  OnAgreeEvent({required this.isAgree});
}
