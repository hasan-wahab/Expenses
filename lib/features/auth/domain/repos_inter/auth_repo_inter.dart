import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepoInter {
  Future login({required String email, required String password});
  Future create({
    String? name,
    required String email,
    required String password,
  });
  Future<bool> logout();
  Future<UserModel> getCurrentUser();
  Future loginWithFingerPrint();
}
