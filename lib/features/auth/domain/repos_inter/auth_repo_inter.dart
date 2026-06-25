import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepoInter {
  Future login({required String email, required String password});
  Future create();
  Future<bool> logout();
  Future<User> getCurrentUser();
}
