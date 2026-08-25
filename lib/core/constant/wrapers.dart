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
  final String? propertyOwnerId;
  final bool isSharedWithMe;
  final String? propertyName;

  AddExpenseArgs({
    required this.propertyCardId,
    this.mode = AddExpenseMode.fromCard,
    this.propertyOwnerId,
    this.isSharedWithMe = false,
    this.propertyName,
  });
}

class SummaryArgs {
  final int propertyCardId;
  final String? propertyOwnerId;
  final bool isSharedWithMe;
  final double monthlyBudget;
  final bool canAddExpense;
  final String? propertyName;

  SummaryArgs({
    required this.propertyCardId,
    this.propertyOwnerId,
    this.isSharedWithMe = false,
    this.monthlyBudget = 0,
    this.canAddExpense = true,
    this.propertyName,
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

class SharePropertyArgs {
  final DashboardCardEntity cardEntity;
  SharePropertyArgs({required this.cardEntity});
}
