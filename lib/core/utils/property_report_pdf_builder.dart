import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// One expense row for PDF / preview.
class PdfExpenseItem {
  const PdfExpenseItem({
    required this.name,
    required this.date,
    required this.price,
    required this.description,
  });

  final String name;
  final String date;
  final String price;
  final String description;
}

/// Builds Property Report PDF (header + all expenses list).
class PropertyReportPdfBuilder {
  PropertyReportPdfBuilder._();

  static const PdfColor _teal = PdfColor.fromInt(0xFF00685B);
  static const PdfColor _badgeBg = PdfColor.fromInt(0xFFD9F2EF);
  static const PdfColor _textBlack = PdfColor.fromInt(0xFF1A1A1A);
  static const PdfColor _textGrey = PdfColor.fromInt(0xFF555555);
  static const PdfColor _labelGrey = PdfColor.fromInt(0xFF888888);
  static const PdfColor _divider = PdfColor.fromInt(0xFFE0E0E0);
  static const PdfColor _border = PdfColor.fromInt(0xFFBDBDBD);

  static Future<Uint8List> buildPdf({
    required String propertyName,
    required String location,
    required String totalExpenses,
    required String reportingPeriod,
    List<PdfExpenseItem> expenses = const [],
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          buildCard(
            propertyName: propertyName,
            location: location,
            totalExpenses: totalExpenses,
            reportingPeriod: reportingPeriod,
          ),
          if (expenses.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text(
              'All Expenses',
              style: pw.TextStyle(
                color: _textBlack,
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 12),
            ...expenses.map(
              (e) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: buildExpenseCard(e),
              ),
            ),
          ],
        ],
      ),
    );
    return doc.save();
  }

  static pw.Widget buildCard({
    required String propertyName,
    required String location,
    required String totalExpenses,
    required String reportingPeriod,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
        border: pw.Border.all(color: _border, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: pw.BoxDecoration(
              color: _badgeBg,
              borderRadius: pw.BorderRadius.circular(20),
            ),
            child: pw.Text(
              'PROPERTY REPORT',
              style: pw.TextStyle(
                color: _teal,
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            propertyName,
            style: pw.TextStyle(
              color: _textBlack,
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _locationPin(),
              pw.SizedBox(width: 6),
              pw.Expanded(
                child: pw.Text(
                  location,
                  style: const pw.TextStyle(color: _textGrey, fontSize: 12),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 14),
          pw.Divider(color: _divider, thickness: 1),
          pw.SizedBox(height: 14),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total Expenses',
                      style: const pw.TextStyle(color: _textGrey, fontSize: 11),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      totalExpenses,
                      style: pw.TextStyle(
                        color: _teal,
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Reporting Period',
                    style: const pw.TextStyle(color: _textGrey, fontSize: 11),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    reportingPeriod,
                    style: pw.TextStyle(
                      color: _textBlack,
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget buildExpenseCard(PdfExpenseItem item) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(14),
        border: pw.Border.all(color: _border, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: _pdfLabeledValue(
                  label: 'NAME',
                  value: item.name,
                  valueColor: _textBlack,
                  align: pw.CrossAxisAlignment.start,
                ),
              ),
              pw.Expanded(
                child: _pdfLabeledValue(
                  label: 'DATE',
                  value: item.date,
                  valueColor: _textBlack,
                  align: pw.CrossAxisAlignment.center,
                ),
              ),
              pw.Expanded(
                child: _pdfLabeledValue(
                  label: 'PRICE',
                  value: item.price,
                  valueColor: _teal,
                  align: pw.CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Divider(color: _divider, thickness: 1),
          pw.SizedBox(height: 10),
          pw.Text(
            'DESCRIPTIONS',
            style: const pw.TextStyle(
              color: _labelGrey,
              fontSize: 9,
              letterSpacing: 0.4,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            item.description.isEmpty ? '-' : item.description,
            style: const pw.TextStyle(color: _textBlack, fontSize: 11),
          ),
        ],
      ),
    );
  }

  static pw.Widget _pdfLabeledValue({
    required String label,
    required String value,
    required PdfColor valueColor,
    required pw.CrossAxisAlignment align,
  }) {
    return pw.Column(
      crossAxisAlignment: align,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(
            color: _labelGrey,
            fontSize: 9,
            letterSpacing: 0.4,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _locationPin() {
    return pw.Container(
      width: 10,
      height: 10,
      margin: const pw.EdgeInsets.only(top: 1),
      decoration: const pw.BoxDecoration(
        color: _textGrey,
        shape: pw.BoxShape.circle,
      ),
      child: pw.Center(
        child: pw.Container(
          width: 4,
          height: 4,
          decoration: const pw.BoxDecoration(
            color: PdfColors.white,
            shape: pw.BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
