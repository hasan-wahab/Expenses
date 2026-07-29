import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/dashboard/data/models/property_card_model.dart';

class PropertiesRemoteSource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addNewProperty({
    required PropertyModel model,
    required String currentUserEmail,
  }) async {
    try {
      await firestore
          .collection("Property")
          .doc(currentUserEmail)
          .collection('PropertyList')
          .doc(model.cardId.toString())
          .set(model.toMap());
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'resource-exhausted':
          throw "Quta pora hogya";

        case 'unavailable':
          throw Exception("No internet connection");

        case 'permission-denied':
          throw Exception("Access denied");

        default:
          throw Exception(e.message ?? "Unknown error");
      }
    } on TimeoutException {
      throw "Something went wrong. Please try again later.";
    } on Exception {
      rethrow;
    }
  }

  Future<List<PropertyModel>> getPropertiesList({
    required String currentUserEmail,
  }) async {
    try {
      List<PropertyModel> list = [];
      final dataList = await firestore
          .collection('Property')
          .doc(currentUserEmail)
          .collection('PropertyList')
          .get();
      for (var element in dataList.docs) {
        list.add(PropertyModel.fromMap(element.data()));
      }
      return list;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'resource-exhausted':
          throw "Quta pora hogya";

        case 'unavailable':
          throw Exception("No internet connection");

        case 'permission-denied':
          throw Exception("Access denied");

        default:
          throw Exception(e.message ?? "Unknown error");
      }
    } on TimeoutException {
      throw 'Something went wrong. Please try again later.';
    } on Exception {
      rethrow;
    }
  }

  Future updatePropertyById({
    required PropertyModel model,
    required String currentUserEmail,
  }) async {
    try {
      await firestore
          .collection('Property')
          .doc(currentUserEmail)
          .collection('PropertyList')
          .doc(model.cardId.toString())
          .update(model.toMap());
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'resource-exhausted':
          throw "Quta pora hogya";

        case 'unavailable':
          throw Exception("No internet connection");

        case 'permission-denied':
          throw Exception("Access denied");

        default:
          throw Exception(e.message ?? "Unknown error");
      }
    } on TimeoutException {
      throw "Something went wrong. Please try again later.";
    } on Exception {
      rethrow;
    }
  }

  Future deletePropertyById({
    required int cardId,
    required String currentUserEmail,
  }) async {
    try {
      await firestore
          .collection('Property')
          .doc(currentUserEmail)
          .collection('PropertyList')
          .doc(cardId.toString())
          .delete();

      /// delete expenses of property
      final expensesRef = firestore
          .collection('Property')
          .doc(currentUserEmail)
          .collection('PropertyList')
          .doc(cardId.toString())
          .collection('Expenses');
      final snapshot = await expensesRef.get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'resource-exhausted':
          throw "Quta pora hogya";

        case 'unavailable':
          throw Exception("No internet connection");

        case 'permission-denied':
          throw Exception("Access denied");

        default:
          throw Exception(e.message ?? "Unknown error");
      }
    } on TimeoutException {
      throw "Something went wrong. Please try again later.";
    } on Exception {
      rethrow;
    }
  }
}
