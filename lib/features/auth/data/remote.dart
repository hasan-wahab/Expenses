import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/features/auth/data/local.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_repo_inter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class AuthRemote implements AuthRepoInter {
  AuthLocal authLocal;
  AuthRemote({required this.authLocal});
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future login({required String email, required String password}) async {
    try {
      /// User login with email and password
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 15));

      /// Save Current user email in local
      await authLocal.saveCurrentUserEmail(email: email);

      /// Get current user from remote
      UserModel model = await getCurrentUser(email: email);

      /// Save current user data in local
      await authLocal.saveUser(model: model);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } on TimeoutException {
      throw 'Please check your internet connection. Try again later';
    }
  }

  @override
  Future create({
    String? name,
    required String email,
    required String password,
  }) async {
    try {
      /// Create user account
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 15));

      /// Convert data in to Model
      UserModel userModel = UserModel(
        name: name,
        email: email,
        createAt: DateTime.now().toString(),
      );

      /// Save user data in local
      await authLocal.saveUser(model: userModel);

      /// Get user data from local
      userModel = await authLocal.getUser();

      /// Save data in firestore
      await firestore.collection('Users').doc(email).set(userModel.toMap());
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } on TimeoutException {
      throw 'Please check your internet connection. Try again later';
    }
  }

  @override
  Future<UserModel> getCurrentUser({String? email}) async {
    try {
      UserModel? userModel;
      String currentUserEmail = await authLocal.getCurrentUserEmail();
      DocumentSnapshot docSnap = await firestore
          .collection('Users')
          .doc(currentUserEmail.isEmpty ? email : currentUserEmail)
          .get()
          .timeout(const Duration(seconds: 15));
      final data = docSnap.data() as Map<String, dynamic>;
      userModel = UserModel.fromMap(data);

      return userModel;
    } on TimeoutException {
      throw 'Please check your internet connection. Try again later';
    } on Exception {
      rethrow;
    }
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
