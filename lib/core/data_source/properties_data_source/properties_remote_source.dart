import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/core/constant/app_key/firebase_paths.dart';
import 'package:expense_app/core/constant/const_text/share_property_text.dart';
import 'package:expense_app/features/share_property/domain/share_member_ui.dart';
import 'package:expense_app/features/share_property/domain/share_permission_item.dart';

import '../../../features/dashboard/data/models/property_card_model.dart';

class PropertiesRemoteSource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> _propertyPayload({
    required PropertyModel model,
    required String currentUserEmail,
    required String ownerUid,
  }) {
    final id = FirebasePaths.propertyId(
      ownerUid: ownerUid,
      cardId: model.cardId,
    );
    final map = Map<String, dynamic>.from(model.toMap());
    map.remove('isSharedWithMe');
    map.remove('myPermissions');
    return {
      ...map,
      'propertyId': id,
      'ownerId': ownerUid,
      'ownerEmail': currentUserEmail,
    };
  }

  Future addNewProperty({
    required PropertyModel model,
    required String currentUserEmail,
  }) async {
    try {
      final ownerUid = FirebasePaths.requireUid();
      final id = FirebasePaths.propertyId(
        ownerUid: ownerUid,
        cardId: model.cardId,
      );
      await FirebasePaths.propertyDoc(id).set(
        _propertyPayload(
          model: model,
          currentUserEmail: currentUserEmail,
          ownerUid: ownerUid,
        ),
        SetOptions(merge: true),
      );
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
      final ownerUid = FirebasePaths.requireUid();
      final dataList = await FirebasePaths.propertiesCol
          .where('ownerId', isEqualTo: ownerUid)
          .get();
      if (dataList.docs.isNotEmpty) {
        return dataList.docs
            .map((element) => PropertyModel.fromMap(element.data()))
            .toList();
      }

      /// One-time: copy email-nested Property/{email}/PropertyList → Properties
      return await _migrateLegacyProperties(
        currentUserEmail: currentUserEmail,
        ownerUid: ownerUid,
      );
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

  Future<List<PropertyModel>> _migrateLegacyProperties({
    required String currentUserEmail,
    required String ownerUid,
  }) async {
    final legacy = await FirebasePaths.legacyPropertyListCol(
      currentUserEmail,
    ).get();
    if (legacy.docs.isEmpty) return [];

    final list = <PropertyModel>[];
    for (final element in legacy.docs) {
      final model = PropertyModel.fromMap(element.data());
      list.add(model);
      final id = FirebasePaths.propertyId(
        ownerUid: ownerUid,
        cardId: model.cardId,
      );
      await FirebasePaths.propertyDoc(id).set(
        _propertyPayload(
          model: model,
          currentUserEmail: currentUserEmail,
          ownerUid: ownerUid,
        ),
        SetOptions(merge: true),
      );
    }
    return list;
  }

  Future updatePropertyById({
    required PropertyModel model,
    required String currentUserEmail,
    String? ownerUid,
  }) async {
    try {
      final uid = ownerUid ?? FirebasePaths.requireUid();
      final id = FirebasePaths.propertyId(
        ownerUid: uid,
        cardId: model.cardId,
      );
      await FirebasePaths.propertyDoc(id).set(
        {
          ...model.toMap(),
          'propertyId': id,
          if (ownerUid == null || ownerUid == FirebasePaths.currentUid) ...{
            'ownerId': uid,
            'ownerEmail': currentUserEmail,
          },
        },
        SetOptions(merge: true),
      );
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
    String? ownerUid,
  }) async {
    try {
      final uid = ownerUid ?? FirebasePaths.requireUid();
      final id = FirebasePaths.propertyId(ownerUid: uid, cardId: cardId);
      await FirebasePaths.propertyDoc(id).delete();

      final snapshot = await FirebasePaths.expensesCol
          .where('propertyId', isEqualTo: id)
          .get();
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

  Future shareWithFriend({
    required PropertyModel model,
    required String currentUserEmail,
    required String friendUid,
    required String friendEmail,
    String? friendName,
    required List<String> permissions,
  }) async {
    try {
      if (friendUid.isEmpty || friendUid.contains('@')) {
        throw SharePropertyText.askFriendOpenApp;
      }
      final ownerUid = FirebasePaths.requireUid();
      if (friendUid == ownerUid) {
        throw SharePropertyText.cannotShareSelf;
      }
      final perms = _normalizedPermissions(permissions);
      final id = FirebasePaths.propertyId(
        ownerUid: ownerUid,
        cardId: model.cardId,
      );
      final ref = FirebasePaths.propertyDoc(id);

      await firestore
          .runTransaction((tx) async {
            final snap = await tx.get(ref);
            final data = snap.exists && snap.data() != null
                ? Map<String, dynamic>.from(snap.data()!)
                : _propertyPayload(
                    model: model,
                    currentUserEmail: currentUserEmail,
                    ownerUid: ownerUid,
                  );

            final members = _readMembers(data);
            if (members.any((m) => m['friendId']?.toString() == friendUid)) {
              throw SharePropertyText.alreadyShared;
            }

            members.add({
              'friendId': friendUid,
              'friendEmail': friendEmail,
              'friendName': friendName ?? '',
              'permissions': perms,
              'sharedAt': DateTime.now().toIso8601String(),
            });

            final memberIds = _readStringList(data['memberIds']);
            if (!memberIds.contains(friendUid)) {
              memberIds.add(friendUid);
            }

            final memberPermissions = _readPermissionsMap(
              data['memberPermissions'],
            );
            memberPermissions[friendUid] = perms;

            tx.set(ref, {
              ...data,
              'members': members,
              'memberIds': memberIds,
              'memberPermissions': memberPermissions,
            }, SetOptions(merge: true));
          })
          .timeout(const Duration(seconds: 20));
    } on FirebaseException catch (e) {
      _throwFirebase(e);
    } on TimeoutException {
      throw SharePropertyText.shareFailed;
    } on Exception {
      rethrow;
    }
  }

  Future unshareFriend({
    required int cardId,
    required String friendUid,
  }) async {
    try {
      final ownerUid = FirebasePaths.requireUid();
      final id = FirebasePaths.propertyId(ownerUid: ownerUid, cardId: cardId);
      final ref = FirebasePaths.propertyDoc(id);

      await firestore
          .runTransaction((tx) async {
            final snap = await tx.get(ref);
            if (!snap.exists || snap.data() == null) return;
            final data = Map<String, dynamic>.from(snap.data()!);
            final members = _readMembers(
              data,
            ).where((m) => m['friendId']?.toString() != friendUid).toList();
            final memberIds = _readStringList(
              data['memberIds'],
            ).where((id) => id != friendUid).toList();
            final memberPermissions = _readPermissionsMap(
              data['memberPermissions'],
            );
            memberPermissions.remove(friendUid);

            tx.update(ref, {
              'members': members,
              'memberIds': memberIds,
              'memberPermissions': memberPermissions,
            });
          })
          .timeout(const Duration(seconds: 20));
    } on FirebaseException catch (e) {
      _throwFirebase(e);
    } on TimeoutException {
      throw SharePropertyText.shareFailed;
    } on Exception {
      rethrow;
    }
  }

  Future<List<ShareMemberUi>> getMembers({required int cardId}) async {
    try {
      final ownerUid = FirebasePaths.requireUid();
      final id = FirebasePaths.propertyId(ownerUid: ownerUid, cardId: cardId);
      final snap = await FirebasePaths.propertyDoc(
        id,
      ).get(const GetOptions(source: Source.server)).timeout(
        const Duration(seconds: 15),
      );
      if (!snap.exists || snap.data() == null) return [];
      return _readMembers(snap.data()!)
          .map(_memberFromMap)
          .where((m) => m.email.isNotEmpty || (m.uid?.isNotEmpty ?? false))
          .toList();
    } on FirebaseException catch (e) {
      _throwFirebase(e);
    } on TimeoutException {
      throw SharePropertyText.shareFailed;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> canMemberAddExpense({
    required String ownerUid,
    required int cardId,
  }) async {
    try {
      if (ownerUid.isEmpty) return false;
      final uid = FirebasePaths.requireUid();
      final id = FirebasePaths.propertyId(ownerUid: ownerUid, cardId: cardId);
      final snap = await FirebasePaths.propertyDoc(id)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 15));
      if (!snap.exists || snap.data() == null) return false;
      final data = snap.data()!;
      final ids = _readStringList(data['memberIds']);
      if (!ids.contains(uid)) return false;
      final perms = _readStringList(
        data['memberPermissions'] is Map
            ? (data['memberPermissions'] as Map)[uid]
            : null,
      );
      if (perms.contains(SharePermissionItem.addExpense)) return true;
      final mine = _readMembers(
        data,
      ).where((m) => m['friendId']?.toString() == uid);
      if (mine.isEmpty) return false;
      return _readStringList(
        mine.first['permissions'],
      ).contains(SharePermissionItem.addExpense);
    } on FirebaseException {
      return false;
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    }
  }

  Future<List<PropertyModel>> getSharedWithMe() async {
    try {
      final uid = FirebasePaths.requireUid();
      final result = await FirebasePaths.propertiesCol
          .where('memberIds', arrayContains: uid)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 15));
      if (result.docs.isEmpty) return [];

      return result.docs
          .map((doc) => _sharedPropertyFromData(doc.data(), uid))
          .where((item) => item.isSharedWithMe && !item.isDeleted)
          .toList();
    } on FirebaseException catch (e) {
      _throwFirebase(e);
    } on TimeoutException {
      return [];
    } on Exception {
      rethrow;
    }
  }

  PropertyModel _sharedPropertyFromData(
    Map<String, dynamic> data,
    String myUid,
  ) {
    final model = PropertyModel.fromMap(data);
    final ownerId = data['ownerId']?.toString() ?? '';
    var perms = _readStringList(
      data['memberPermissions'] is Map
          ? (data['memberPermissions'] as Map)[myUid]
          : null,
    );
    if (perms.isEmpty) {
      final mine = _readMembers(
        data,
      ).where((m) => m['friendId']?.toString() == myUid);
      if (mine.isNotEmpty) {
        perms = _readStringList(mine.first['permissions']);
      }
    }
    if (!perms.contains(SharePermissionItem.viewSummary)) {
      perms = [SharePermissionItem.viewSummary, ...perms];
    }
    return model.copyWith(
      ownerId: ownerId,
      ownerEmail: data['ownerEmail']?.toString(),
      isSharedWithMe: ownerId.isNotEmpty && ownerId != myUid,
      myPermissions: perms,
    );
  }

  ShareMemberUi _memberFromMap(Map<String, dynamic> map) {
    return ShareMemberUi(
      uid: map['friendId']?.toString(),
      name: map['friendName']?.toString(),
      email: (map['friendEmail'] ?? '').toString(),
      permissions: _readStringList(map['permissions']),
    );
  }

  List<Map<String, dynamic>> _readMembers(Map<String, dynamic> data) {
    final raw = data['members'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  List<String> _readStringList(dynamic value) {
    if (value is! List) return [];
    return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
  }

  Map<String, List<String>> _readPermissionsMap(dynamic value) {
    if (value is! Map) return {};
    return value.map(
      (key, perms) => MapEntry(key.toString(), _readStringList(perms)),
    );
  }

  List<String> _normalizedPermissions(List<String> permissions) {
    final next = permissions.toSet();
    next.add(SharePermissionItem.viewSummary);
    return next.toList();
  }

  Never _throwFirebase(FirebaseException e) {
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
  }
}
