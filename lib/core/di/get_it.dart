import 'package:expense_app/core/di/di_module/dashboard_di_module.dart';
import 'package:expense_app/core/di/di_module/db_di_module.dart';
import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/core/di/di_module/property_di_module.dart';
import 'package:expense_app/core/di/di_module/settings_di_model.dart';
import 'package:get_it/get_it.dart';

import 'di_module/auth_di_module.dart';
import 'di_module/image_picker_di_module.dart';
import 'di_module/nave_bar_module.dart';
import 'di_module/sync_data_module.dart';

final sl = GetIt.instance;

Future getITSetup() async {
  List<DIModule> diModules = [
    DbDiModule(sl),
    AuthDiModule(sl),
    SyncDataDiModule(sl),
    DashboardDiModule(sl),
    PropertyDiModule(sl),
    NaveBarDiModule(sl),
    SettingsDiModel(sl),
    ImagePickerDiModule(sl),
  ];

  for (var element in diModules) {
    await element.init();
  }
}
