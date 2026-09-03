import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firestore layout (flat — no email-nested folders):
///
/// Expenseo / Data / Users / {uid}
/// Expenseo / Data / Properties / {ownerUid}_{cardId}
/// Expenseo / Data / Expenses / {ownerUid}_{expenseId}
/// Expenseo / Data / Shares / {friendUid}_{propertyId}
///
/// Property still holds members / memberIds / memberPermissions.
/// Shares is the friend-readable index (query-safe).
class FirebasePaths {
  FirebasePaths._();

  static FirebaseFirestore get _db => FirebaseFirestore.instance;

  static const String appName = 'Expenseo';
  static const String data = 'Data';
  static const String users = 'Users';
  static const String properties = 'Properties';
  static const String expenses = 'Expenses';
  static const String shares = 'Shares';

  /// Old nested tree — read-only migrate
  static const String legacyProperty = 'Property';
  static const String legacyPropertyList = 'PropertyList';

  static DocumentReference<Map<String, dynamic>> get dataDoc {
    return _db.collection(appName).doc(data);
  }

  static String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  static String requireUid() {
    final uid = currentUid;
    if (uid == null || uid.isEmpty) {
      throw 'No signed-in user. Please log in again.';
    }
    return uid;
  }

  /// Same id Ali + Rehman use — never a second property doc.
  static String propertyId({required String ownerUid, required int cardId}) {
    return '${ownerUid}_$cardId';
  }

  static String expenseId({required String ownerUid, required int expenseId}) {
    return '${ownerUid}_$expenseId';
  }

  // ── Users ──────────────────────────────────────────────

  static CollectionReference<Map<String, dynamic>> get usersCol {
    return dataDoc.collection(users);
  }

  static DocumentReference<Map<String, dynamic>> userDoc(String uid) {
    return usersCol.doc(uid);
  }

  /// Pre-flat docs were Users/{email}
  static DocumentReference<Map<String, dynamic>> legacyUserDoc(String email) {
    return usersCol.doc(email);
  }

  // ── Properties ─────────────────────────────────────────

  static CollectionReference<Map<String, dynamic>> get propertiesCol {
    return dataDoc.collection(properties);
  }

  static DocumentReference<Map<String, dynamic>> propertyDoc(
    String propertyId,
  ) {
    return propertiesCol.doc(propertyId);
  }

  static CollectionReference<Map<String, dynamic>> get sharesCol {
    return dataDoc.collection(shares);
  }

  static String shareId({
    required String friendUid,
    required String propertyId,
  }) {
    return '${friendUid}_$propertyId';
  }

  static DocumentReference<Map<String, dynamic>> shareDoc({
    required String friendUid,
    required String propertyId,
  }) {
    return sharesCol.doc(shareId(friendUid: friendUid, propertyId: propertyId));
  }

  // ── Expenses ───────────────────────────────────────────

  static CollectionReference<Map<String, dynamic>> get expensesCol {
    return dataDoc.collection(expenses);
  }

  static DocumentReference<Map<String, dynamic>> expenseDoc(String expenseId) {
    return expensesCol.doc(expenseId);
  }

  // ── Legacy nested (migrate only) ───────────────────────

  static CollectionReference<Map<String, dynamic>> get legacyPropertyCol {
    return dataDoc.collection(legacyProperty);
  }

  static CollectionReference<Map<String, dynamic>> legacyPropertyListCol(
    String email,
  ) {
    return legacyPropertyCol.doc(email).collection(legacyPropertyList);
  }

  static CollectionReference<Map<String, dynamic>> legacyExpensesCol({
    required String email,
    required String cardId,
  }) {
    return legacyPropertyListCol(email).doc(cardId).collection(expenses);
  }
}
