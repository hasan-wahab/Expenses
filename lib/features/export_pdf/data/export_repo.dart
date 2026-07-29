import 'dart:typed_data';

import 'package:expense_app/core/data_source/expense_data_source/expense_local_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/utils/export_pdf_utils.dart';
import 'package:expense_app/features/add_expenses/data/models/expense_model.dart';
import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:pdf/pdf.dart';

import '../../../core/utils/downloads_saver.dart';
import '../../../core/utils/property_report_pdf_builder.dart';

class ExportRepo {
  ExpenseLocalSource expenseLocalSource;
  PropertiesLocalSource propertiesLocalSource;
  ExportRepo({
    required this.expenseLocalSource,
    required this.propertiesLocalSource,
  });

  Future<List<ExpenseModel>> exportToPdf({
    required String propertyCardId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    List<ExpenseModel> expenses = await expenseLocalSource.getAllExpenses(
      propertyCardId: propertyCardId,
    );
    final filteredExpenses = ExportPdfUtils().filterExpenses(
      expenses: expenses,
      startDate: startDate,
      endDate: endDate,
    );
    return filteredExpenses;
  }

  Future<List<DashboardCardEntity>> getAllPropertyCard() async {
    String currentUserEmail = await propertiesLocalSource.getCurrentUserEmail();
    List<PropertyModel> properties = await propertiesLocalSource
        .getPropertiesList(currentUserEmail: currentUserEmail);
    return List<DashboardCardEntity>.from(properties.map((e) => e.toEntity()));
  }

  Future<Uint8List> buildPdf({
    required String propertyName,
    required String location,
    required String totalExpenses,
    required String reportingPeriod,
    List<PdfExpenseItem> expenses = const [],
  }) async {
    try {
      final pdfBytes = await PropertyReportPdfBuilder.buildPdf(
        propertyName: propertyName,
        location: location,
        totalExpenses: totalExpenses,
        reportingPeriod: reportingPeriod,
        expenses: expenses,
      );
      return pdfBytes;
    } catch (e) {
      rethrow;
    }
  }

  Future downloadPdf({
    required Uint8List pdfBytes,
    required String propertyName,
  }) async {
    try {
      await DownloadsSaver.savePdf(
        fileName: '$propertyName.pdf',
        bytes: pdfBytes,
      );
    } catch (e) {
      rethrow;
    }
  }
}
