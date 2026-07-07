import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/auth/data/local.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:expense_app/features/auth/data/remote.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:expense_app/features/settings/domain/repos_inter/settings_interface.dart';

class SettingsLocalRepo implements SettingsInterface {
  AuthLocal authLocal;
  AuthRemote authRemote;
  SqfLiteCurd sqfLiteCurd;
  SettingsLocalRepo({
    required this.sqfLiteCurd,
    required this.authRemote,
    required this.authLocal,
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
    userModel = await authLocal.getUser();
    if (userModel.email == '') {
      userModel = await authRemote.getCurrentUser();
    }
    SettingsEntityModel settingsEntityModel = SettingsEntityModel(
      name: userModel.name.toString(),
      email: userModel.email.toString(),
    );
    return settingsEntityModel;
  }
}
