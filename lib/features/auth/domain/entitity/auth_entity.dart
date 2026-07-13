


import '../../../../core/constant/enums.dart';

class AuthEntity {
  final String? name;
  final String? email;
  final LoginType? loginWith;
  final String? password;
  AuthEntity({this.name, this.email, this.loginWith, this.password});
}
