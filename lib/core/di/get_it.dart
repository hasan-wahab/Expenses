import 'dart:math';

import 'package:expense_app/core/di/di_module/add_expense_di_module.dart';
import 'package:expense_app/core/di/di_module/db_di_module.dart';
import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/core/storage/sqflite.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/core/utils/image_picker.dart';
import 'package:expense_app/features/add_property/domain/usescases/add_property_usecases.dart';
import 'package:expense_app/features/add_property/presentation/bloc/add_property_bloc.dart';
import 'package:expense_app/features/auth/data/local.dart';
import 'package:expense_app/features/auth/data/remote.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_repo_inter.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_app/features/dashboard/data/local.dart';
import 'package:expense_app/features/dashboard/data/remote.dart';
import 'package:expense_app/features/dashboard/domain/repos_inter/dashboard_repo_inter.dart';
import 'package:expense_app/features/dashboard/domain/usescases/dashboard_use_case.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/settings/data/local.dart';
import 'package:expense_app/features/settings/domain/repos_inter/settings_interface.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/add_property/data/images/image_source_repo.dart';
import 'di_module/add_property_di_module.dart';
import 'di_module/auth_di_module.dart';
import 'di_module/dashboard_di_module.dart';
import 'di_module/image_picker_di_module.dart';
import 'di_module/nave_bar_module.dart';
import 'di_module/settings_di_module.dart';

final sl = GetIt.instance;

Future getITSetup() async {
  List<DIModule> diModules = [
    DbDiModule(sl),
    SettingsDiModule(sl),
    AuthDIModule(sl),
    DashboardDiModule(sl),
    AddPropertyDiModule(sl),
    NaveBarDiModule(sl),
    ImagePickerDiModule(sl),
    AddExpenseDiModule(sl: sl),
  ];

  for (var element in diModules) {
    await element.init();
  }
}
