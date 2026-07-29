import 'dart:async';
import 'dart:typed_data';

import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';

import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';

abstract class ExportToPdfStates {}

class GetExpenseByPeriod extends ExportToPdfStates {
  Status status;
  String message;
  FutureOr<Uint8List>? pdfBytes;
  GetExpenseByPeriod({required this.status, this.pdfBytes, this.message = ''});
}

class GetAllPropertyCard extends ExportToPdfStates {
  Status status;
  String message;
  List<DashboardCardEntity>? cardEntities;
  GetAllPropertyCard({
    required this.status,
    this.cardEntities,
    this.message = '',
  });
}

class BuildPdfState extends ExportToPdfStates {
  Status status;
  String message;
  Uint8List? pdfBytes;
  BuildPdfState({required this.status, this.pdfBytes, this.message = ''});
}

class DownloadPdfState extends ExportToPdfStates {
  Status status;
  String message;
  DownloadPdfState({required this.status, this.message = ''});
}
