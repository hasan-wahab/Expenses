import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/extensions/date_extension.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
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
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.code;
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
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      UserModel? userModel = await authLocal.getUser();
      DocumentSnapshot docSnap = await firestore
          .collection('User')
          .doc(userModel.email)
          .get();
      final data = docSnap.data() as Map<String, dynamic>;
      userModel = UserModel.fromMap(data);
      print(userModel.email);

      return userModel;
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
