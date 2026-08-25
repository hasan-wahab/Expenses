import 'dart:typed_data';

import 'package:expense_app/core/constant/app_currency.dart';

import '../../../../core/utils/property_report_pdf_builder.dart';
import '../../../add_expenses/data/models/expense_model.dart';
import '../../../dashboard/domain/entitity/dashboard_card_entity.dart';
import '../../data/export_repo.dart';

class ExportToPdfUseCases {
  ExportRepo exportRepo;
  ExportToPdfUseCases({required this.exportRepo});

  Future exportToPdfCall({
    required String propertyCardId,
    required String propertyName,
    required String location,
    required String reportingPeriod,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    List<ExpenseModel> expenses = await exportRepo.exportToPdf(
      propertyCardId: propertyCardId,
      startDate: startDate,
      endDate: endDate,
    );
    List<PdfExpenseItem> expenseItems = expenses
        .map(
          (e) => PdfExpenseItem(
            name: e.title.toString(),
            date: e.date.toString(),
            price: AppCurrency.format(e.amount),
            description: e.note.toString(),
          ),
        )
        .toList();
    final double totalExpense = expenses.fold<double>(
      0,
      (sum, e) => sum + (e.amount ?? 0),
    );
    return buildPdfCall(
      propertyName: propertyName,
      location: location,
      totalExpenses: AppCurrency.format(totalExpense),
      reportingPeriod: reportingPeriod,
      expenses: expenseItems,
    );
  }
  Future<Uint8List> buildPdfCall({
    required String propertyName,
    required String location,
    required String totalExpenses,
    required String reportingPeriod,
    List<PdfExpenseItem> expenses = const [],
  })
  async {
    Uint8List pdfBytes = await exportRepo.buildPdf(
      propertyName: propertyName,
      location: location,
      totalExpenses: totalExpenses,
      reportingPeriod: reportingPeriod,
      expenses: expenses,
    );
    return pdfBytes;
  }





  Future<List<DashboardCardEntity>> getAllPropertyCardCall() async {
    List<DashboardCardEntity> cardEntities = await exportRepo
        .getAllPropertyCard();
    return cardEntities;
  }



  Future downloadPdfCall({
    required Uint8List pdfBytes,
    required String propertyName,
  }) async {
    await exportRepo.downloadPdf(
      pdfBytes: pdfBytes,
      propertyName: propertyName,
    );
  }
}
