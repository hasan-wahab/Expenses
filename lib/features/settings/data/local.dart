import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/data_source/auth_data_source/auth_remote_source.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/core/utils/profile_image_utils.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:expense_app/features/settings/domain/repos_inter/settings_interface.dart';

class SettingsLocalRepo implements SettingsInterface {
  SqfLiteCurd sqfLiteCurd;
  AuthRemoteSource authRemoteSource;
  SettingsLocalRepo({
    required this.sqfLiteCurd,
    required this.authRemoteSource,
  });

  @override
  Future addFingerPrint() async {
    final Map<String, int> value = {'finger_print': 1};
    await sqfLiteCurd.save(tableKey: TableKeys.fingerPrintTable, value: value);
  }

  @override
  Future removeFingerPrint() async {
    await sqfLiteCurd.delete(tableKey: TableKeys.fingerPrintTable);
  }

  @override
  Future<bool> getFingerPrint() async {
    List<Map<String, dynamic>> result = await sqfLiteCurd.get(
      tableKey: TableKeys.fingerPrintTable,
    );

    if (result.isEmpty) return false;
    final value = result.first['finger_print'];

    if (value == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<SettingsEntityModel> settingsProfileCardData() async {
    UserModel userModel = UserModel();
    List<Map<String, dynamic>> email = await sqfLiteCurd.get(
      tableKey: TableKeys.currentUserEmailTable,
    );
    if (email.isEmpty) {
      return SettingsEntityModel();
    }
    final currentEmail = email.first['email'].toString();
    final result = await sqfLiteCurd.get(
      tableKey: TableKeys.userTable,
      whereArgs: [currentEmail],
      where: 'email = ?',
    );
    if (result.isNotEmpty) {
      userModel = UserModel.fromMap(result.first);
    }

    final localName = userModel.name.orEmpty;
    final name = localName.hasValue
        ? localName
        : authRemoteSource.displayName.orEmpty;

    /// Prefer valid local file / stored https; else Auth photoURL
    var imageUrl = resolveProfileImageUrl(
      storedImageUrl: userModel.imageUrl,
      networkFallbackUrl: authRemoteSource.photoUrl,
    );

    /// No local/Auth image → load https imageUrl from Firestore for this email
    if (imageUrl.isEmpty) {
      final remoteUser = await authRemoteSource.getUserByEmail(currentEmail);
      final remoteImage = remoteUser?.imageUrl.orEmpty ?? '';
      if (remoteImage.isNetworkUrl) {
        imageUrl = remoteImage;
      } else {
        imageUrl = resolveProfileImageUrl(
          storedImageUrl: remoteImage,
          networkFallbackUrl: authRemoteSource.photoUrl,
        );
      }
    }

    return SettingsEntityModel(
      name: name,
      email: userModel.email.orEmpty.isNotEmpty
          ? userModel.email.orEmpty
          : authRemoteSource.currentUserEmail.orEmpty,
      phone: userModel.phone.orEmpty,
      imageUrl: imageUrl,
    );
  }
}
