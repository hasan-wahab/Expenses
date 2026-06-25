abstract class AuthEvents {}

class OnPressedLoginEvent extends AuthEvents {
  final String email;
  final String password;

  OnPressedLoginEvent({required this.email, required this.password});
}
