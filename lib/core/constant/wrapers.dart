import 'dart:async';
import 'dart:typed_data';

import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:pdf/pdf.dart';

import 'enums.dart';

class AppPropertyArgs {
  final DashboardCardEntity? cardEntity;
  final AddPropertyMode mode;
  AppPropertyArgs({this.cardEntity, this.mode = AddPropertyMode.add});
}

class AddExpenseArgs {
  final String propertyCardId;
  final AddExpenseMode mode;
  AddExpenseArgs({
    required this.propertyCardId,
    this.mode = AddExpenseMode.fromCard,
  });
}

class PersonalInfoArgs {
  PersonalInfoMode mode;
  SettingsEntityModel? entity;
  PersonalInfoArgs({this.mode = PersonalInfoMode.add, this.entity});
}

class PdfPreviewArgs {
  final String propertyName;
  FutureOr<Uint8List> Function(PdfPageFormat) build;
  PdfPreviewArgs({required this.build, required this.propertyName});
}
