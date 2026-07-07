import 'dart:math';

import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/auth/data/local.dart';
import 'package:expense_app/features/auth/domain/entitity/auth_entity.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_repo_inter.dart';

class AuthUseCases {
  final AuthRepoInter authRepoInter;
  AuthUseCases({required this.authRepoInter});

  Future createUser({
    required String name,
    required String email,
    required String password,
    required String cPassword,
    required bool isAgree,
  }) async {
    if (await InternetUtils.isInternetAvailable()) {
      if (name.isEmpty &&
          email.isEmpty &&
          password.isEmpty &&
          cPassword.isEmpty) {
        throw Exception('Please Enter required fields !');
      }

      if (name == '' && email == '' && password == '' && cPassword == '') {
        throw Exception('Please Enter required fields !');
      }
      if (password != cPassword) {
        throw Exception('Please enter to correct confirm password');
      }
      if (!isAgree) {
        throw Exception('Please accept the Terms & Conditions to continue.');
      }
      await authRepoInter.create(name: name, email: email, password: password);
    } else {
      throw Exception('Please check your internet connections!');
    }
  }

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

  Future loginWithFingerPrint() async {
    await authRepoInter.loginWithFingerPrint();
  }

  bool obscurePassword({bool isObscure = true}) {
    return isObscure = !isObscure;
  }
}
