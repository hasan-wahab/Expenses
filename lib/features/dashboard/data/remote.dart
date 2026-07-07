import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/features/dashboard/data/models/dashboard_card_model.dart';
import 'package:expense_app/features/dashboard/domain/repos_inter/dashboard_repo_inter.dart';

class DashboardRemote extends DashboardRepoInter {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future save({required DashboardCardModel model}) async {
    try {
      await firestore
          .collection('Property')
          .doc(model.cardId.toString())
          .set(model.toMap());
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  @override
  Future<List<DashboardCardModel>> get() async {
    try {
      final docSnap = await firestore.collection('Property').get();
      List<DashboardCardModel> list = [];
      list = docSnap.docs
          .map((e) => DashboardCardModel.fromMap(e.data()))
          .toList();

      return list;
    } on FirebaseException catch (e) {
      throw e.code;
    } on Exception {
      rethrow;
    }
  }

  @override
  Future delete({required String dashboardCardId}) async {
    try {
      await firestore.collection('Property').doc(dashboardCardId).delete();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  @override
  Future update({required DashboardCardModel model}) async {
    try {
      await firestore
          .collection('Property')
          .doc(model.cardId.toString())
          .update(model.toMap());
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
