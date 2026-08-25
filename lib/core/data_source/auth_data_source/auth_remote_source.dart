import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/core/constant/app_key/firebase_paths.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRemoteSource {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> _userFirestoreMap({
    required String uid,
    required UserModel model,
  }) {
    return {
      'uid': uid,
      'name': model.name ?? auth.currentUser?.displayName ?? '',
      'email': model.email ?? auth.currentUser?.email ?? '',
      'loginWith': 'emailAndPassword',
      'createAt': model.createAt ?? DateTime.now().toIso8601String(),
      'updateAt': DateTime.now().toIso8601String(),
      'phone': model.phone ?? '',
      'imageUrl': model.imageUrl ?? auth.currentUser?.photoURL ?? '',
    };
  }

  /// Auth token must be ready before Firestore rules allow Users/{uid}.
  Future<String> _uidWithToken() async {
    final user = auth.currentUser;
    final uid = user?.uid;
    if (user == null || uid == null || uid.isEmpty) {
      throw 'No signed-in user. Please log in again.';
    }
    /// Do not force-refresh (getIdToken(true)) — that retriggers listeners
    /// and can loop Users writes.
    await user.getIdToken().timeout(Duration(seconds: 15));
    return uid;
  }

  /// Expenseo / Data / Users / {uid}
  /// Transaction hits the server (local cache `.set` can succeed while Console stays empty).
  /// New uid → create. Same uid → update (`createAt` kept).
  Future<Map<String, dynamic>> saveUserProfile({
    required UserModel model,
  }) async {
    final uid = await _uidWithToken();
    final ref = FirebasePaths.userDoc(uid);
    final incoming = _userFirestoreMap(uid: uid, model: model);

    try {
      final saved = await firestore
          .runTransaction<Map<String, dynamic>>((tx) async {
            final snap = await tx.get(ref);
            if (snap.exists) {
              final existing = snap.data() ?? {};
              final updated = {
                ...incoming,
                'createAt': existing['createAt'] ?? incoming['createAt'],
                'updateAt': DateTime.now().toIso8601String(),
              };
              tx.set(ref, updated, SetOptions(merge: true));
              debugPrint('Users UPDATE → Expenseo/Data/Users/$uid');
              return updated;
            }
            tx.set(ref, incoming);
            debugPrint('Users CREATE → Expenseo/Data/Users/$uid');
            return incoming;
          })
          .timeout(Duration(seconds: 20));

      final server = await ref
          .get(GetOptions(source: Source.server))
          .timeout(Duration(seconds: 15));
      if (!server.exists) {
        debugPrint('Users SET FAILED: not on server after write');
        throw 'Users not saved on Firebase. Publish Firestore rules, then try again.';
      }
      debugPrint('Users SAVED on server → Expenseo/Data/Users/$uid');
      return saved;
    } on FirebaseException catch (e) {
      debugPrint('Users SET FAILED ${e.code}: ${e.message}');
      throw 'Users not saved (${e.code}). Check Firestore rules.';
    }
  }

  Future<void> create({required UserModel model}) async {
    try {
      final credential = await auth
          .createUserWithEmailAndPassword(
            email: model.email.toString(),
            password: model.password.toString(),
          )
          .timeout(Duration(seconds: 15));

      /// Email users have no Google photo — store signup username on Auth profile
      final name = model.name?.trim();
      if (name != null && name.isNotEmpty) {
        await credential.user?.updateDisplayName(name);
      }
      await credential.user?.getIdToken();

      await saveUserProfile(
        model: model.copyWith(loginWith: LoginType.emailAndPassword),
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? e.code;
    } on FirebaseException catch (e) {
      debugPrint('Firestore Users create error: ${e.code} | ${e.message}');
      throw e.message ?? e.code;
    } on TimeoutException {
      throw 'Please check your internet connection and try again';
    } on Exception {
      rethrow;
    }
  }

  Future<void> update({
    required UserModel model,
    required String currentUserEmail,
  }) async {
    try {
      await saveUserProfile(model: model);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? e.code;
    } on FirebaseException catch (e) {
      throw e.message ?? e.code;
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
      await auth.currentUser?.getIdToken();
      final existing = await _userMapForCurrentAuth(email: email);
      final merged = UserModel.fromMap({
        ...?existing,
        'email': email,
        'name': existing?['name'] ?? auth.currentUser?.displayName,
        'imageUrl': existing?['imageUrl'] ?? auth.currentUser?.photoURL,
      });
      await saveUserProfile(model: merged);
      return merged;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? e.code;
    } on FirebaseException catch (e) {
      debugPrint('Firestore Users login error: ${e.code} | ${e.message}');
      throw e.message ?? e.code;
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

  User? get currentUser => auth.currentUser;

  bool get isEmailVerified => auth.currentUser?.emailVerified ?? false;

  String? get currentUserEmail => auth.currentUser?.email;

  /// Username / Google display name from Firebase Auth user
  String? get displayName => auth.currentUser?.displayName;

  /// Google photo URL when available (email signup has none)
  String? get photoUrl => auth.currentUser?.photoURL;
  Future<void> updateDisplayName(String name) async {
    await auth.currentUser?.updateDisplayName(name);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final data = await _userMapByEmail(email);
      if (data == null) return null;
      return UserModel.fromMap(data);
    } on Exception {
      return null;
    }
  }

  /// Users/{uid}. If missing, copy legacy Users/{email}.
  Future<Map<String, dynamic>?> _userMapForCurrentAuth({
    required String email,
  }) async {
    try {
      final uid = FirebasePaths.requireUid();
      final uidDoc = await FirebasePaths.userDoc(uid)
          .get(GetOptions(source: Source.server))
          .timeout(Duration(seconds: 15));
      if (uidDoc.exists && uidDoc.data() != null) {
        return uidDoc.data();
      }

      final legacy = await FirebasePaths.legacyUserDoc(
        email,
      ).get().timeout(Duration(seconds: 15));
      if (legacy.exists && legacy.data() != null) {
        return {...legacy.data()!, 'uid': uid};
      }
      return null;
    } on Exception catch (e) {
      debugPrint('_userMapForCurrentAuth: $e');
      return null;
    }
  }

  /// Create Users/{uid} if missing on server; update if it already exists.
  Future<Map<String, dynamic>?> ensureUserDoc({UserModel? local}) async {
    if (auth.currentUser == null) return null;
    final model =
        local ??
        UserModel(
          name: auth.currentUser?.displayName,
          email: auth.currentUser?.email,
          loginWith: LoginType.emailAndPassword,
        );
    return await saveUserProfile(model: model);
  }

  /// Looks up Expenseo/Data/Users by email on the server (for share).
  Future<Map<String, dynamic>?> findRegisteredUserByEmail(String email) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return null;
    final lower = trimmed.toLowerCase();
    final emails = <String>{trimmed, lower}.toList();

    final query = await FirebasePaths.usersCol
        .where('email', whereIn: emails)
        .limit(2)
        .get(GetOptions(source: Source.server))
        .timeout(Duration(seconds: 15));
    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      return {'uid': query.docs.first.id, ...data};
    }

    for (final value in emails) {
      final legacy = await FirebasePaths.legacyUserDoc(value)
          .get(GetOptions(source: Source.server))
          .timeout(Duration(seconds: 10));
      if (legacy.exists && legacy.data() != null) {
        return {'uid': legacy.id, ...legacy.data()!};
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> _userMapByEmail(String email) async {
    final query = await FirebasePaths.usersCol
        .where('email', isEqualTo: email)
        .limit(1)
        .get()
        .timeout(Duration(seconds: 15));
    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }

    final legacy = await FirebasePaths.legacyUserDoc(
      email,
    ).get().timeout(Duration(seconds: 15));
    if (!legacy.exists || legacy.data() == null) return null;
    return legacy.data();
  }

  Future<void> sendEmailVerification() async {
    try {
      var user = auth.currentUser;
      if (user == null) {
        throw 'No signed-in user. Please log in again.';
      }

      await user.reload().timeout(Duration(seconds: 15));
      user = auth.currentUser;
      if (user == null) {
        throw 'No signed-in user. Please log in again.';
      }
      if (user.email == null || user.email!.isEmpty) {
        throw 'No email found on this account.';
      }
      if (user.emailVerified) {
        throw 'Email is already verified.';
      }

      debugPrint('Sending verification email to: ${user.email}');
      await user.sendEmailVerification().timeout(Duration(seconds: 15));
      debugPrint('Firebase accepted verification email request');
    } on FirebaseAuthException catch (e) {
      debugPrint('sendEmailVerification error: ${e.code} | ${e.message}');
      throw e.message ?? e.code;
    } on TimeoutException {
      throw 'Please check your internet connection and try again';
    } on Exception {
      rethrow;
    }
  }

  Future<bool> reloadAndCheckEmailVerified() async {
    try {
      final user = auth.currentUser;
      if (user == null) return false;
      await user.reload().timeout(Duration(seconds: 15));
      return auth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? e.code;
    } on TimeoutException {
      throw 'Please check your internet connection and try again';
    } on Exception {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
