import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteSource {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> create({required UserModel model}) async {
    try {
      await auth
          .createUserWithEmailAndPassword(
            email: model.email.toString(),
            password: model.password.toString(),
          )
          .timeout(Duration(seconds: 15));
      await firestore
          .collection('Users')
          .doc(model.email)
          .set(model.toMap())
          .timeout(Duration(seconds: 15));
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } on TimeoutException {
      throw 'Please check your internet connection and try again';
    } on Exception {
      rethrow;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(Duration(seconds: 15));
      final user = await firestore.collection('Users').doc(email).get();
      if (!user.exists) throw 'User not found!';
      print(user.data());
      return UserModel.fromMap(user.data()!);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } on TimeoutException {
      throw 'Please check your internet connection and try again';
    } on Exception {
      rethrow;
    }
  }

  Future<void> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }
}
