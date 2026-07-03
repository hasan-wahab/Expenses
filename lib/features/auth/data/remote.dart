import 'dart:async';

import 'package:expense_app/features/auth/domain/repos_inter/auth_repo_inter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class AuthRemote implements AuthRepoInter {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Future login({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  @override
  Future<UserCredential> create() {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<User> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future loginWithFingerPrint() async {
    try {
      LocalAuthentication local = LocalAuthentication();
      await local.authenticate(
        localizedReason: 'Use your fingerprint to log in',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
    } on LocalAuthException catch (e) {
      throw e.code;
    }
  }
}
