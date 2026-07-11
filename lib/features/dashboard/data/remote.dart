import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:expense_app/features/auth/data/remote.dart';
import 'package:expense_app/features/dashboard/data/models/dashboard_card_model.dart';
import 'package:expense_app/features/dashboard/domain/repos_inter/dashboard_repo_inter.dart';

class DashboardRemote extends DashboardRepoInter {
  AuthRemote authRemote;
  DashboardRemote({required this.authRemote});
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  /// Save Property in Firebase
  Future save({required DashboardCardModel model}) async {
    try {
      /// Get Current User Email for to pass in Firestore docs,
      String email = await authRemote.authLocal.getCurrentUserEmail();

      await firestore
          .collection('Property')
          .doc(email)
          .collection('PropertyList')
          .doc(model.cardId.toString())
          .set(model.toMap())
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw 'Please check your internet connection. Try again later';
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  @override
  Future<List<DashboardCardModel>> get() async {
    try {
      /// Get Current User Email for to pass in Firestore docs,
      String email = await authRemote.authLocal.getCurrentUserEmail();

      /// Get Property List From Firebase
      final docSnap = await firestore
          .collection('Property')
          .doc(email)
          .collection('PropertyList')
          .orderBy('cardId', descending: true)
          .get()
          .timeout(const Duration(seconds: 15));
      List<DashboardCardModel> list = [];

      /// Loop Through Property List and convert to Model
      list = docSnap.docs
          .map((e) => DashboardCardModel.fromMap(e.data()))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw e.code;
    } on TimeoutException {
      throw 'Please check your internet connection. Try again later';
    } on Exception {
      rethrow;
    }
  }

  @override
  Future delete({required String dashboardCardId}) async {
    try {
      /// Get Current User Email for to pass in Firestore docs,
      String email = await authRemote.authLocal.getCurrentUserEmail();

      /// Delete Property From Firebase
      await firestore
          .collection('Property')
          .doc(email)
          .collection('PropertyList')
          .doc(dashboardCardId)
          .delete()
          .timeout(const Duration(seconds: 15));
    } on FirebaseException catch (e) {
      throw e.code;
    } on TimeoutException {
      throw 'Please check your internet connection. Try again later';
    }
  }

  @override
  Future update({required DashboardCardModel model}) async {
    try {
      /// Get Current User Email for to pass in Firestore docs,
      String email = await authRemote.authLocal.getCurrentUserEmail();

      /// Update Property From Firebase
      await firestore
          .collection('Property')
          .doc(email)
          .collection('PropertyList')
          .doc(model.cardId.toString())
          .update(model.toMap())
          .timeout(const Duration(seconds: 15));
    } on FirebaseException catch (e) {
      throw e.code;
    } on TimeoutException {
      throw 'Please check your internet connection. Try again later';
    }
  }
}
