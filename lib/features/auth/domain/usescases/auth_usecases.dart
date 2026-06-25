import 'dart:math';

import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/auth/domain/entitity/auth_entity.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_repo_inter.dart';

class AuthUseCases {
  final AuthRepoInter authRepoInter;

  AuthUseCases({required this.authRepoInter});

  Future userLogin({required String email, required String password}) async {
    if (await InternetUtils.isInternetAvailable()) {
      if (email.isEmpty && password.isEmpty) {
        throw Exception('Please Enter required fields !');
      }

      if (email == '' && password == '') {
        throw Exception('Please Enter required fields !');
      }

      await authRepoInter.login(email: email, password: password);
    } else {
      throw Exception('Please check your internet connections!');
    }
  }
}
