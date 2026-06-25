class AuthEntity {
  final String? name;
  final String? email;
  final String? password;
  bool isEmailVarified;
  final String? token;

  AuthEntity({
    this.name,
    this.email,
    this.password,
    this.isEmailVarified = false,
    this.token,
  });
}
