import '../../../../core/constant/enums.dart';

class AuthEntity {
  final String? name;
  final String? email;
  final String? phone;
  final LoginType? loginWith;
  final String? password;
  final String? imageUrl;

  AuthEntity({
    this.name,
    this.email,
    this.loginWith,
    this.password,
    this.phone,
    this.imageUrl,
  });
}
