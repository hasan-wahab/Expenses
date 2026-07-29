import 'package:expense_app/core/utils/property_report_pdf_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Property report PDF builds with passed data', () async {
    final bytes = await PropertyReportPdfBuilder.buildPdf(
      propertyName: 'Green Valley Residency',
      location: 'Sector 45, Silicon Hills, California',
      totalExpenses: 'Rs. 24,500',
      reportingPeriod: 'Dec 2021',
    );

    expect(bytes, isNotEmpty);
    // PDF file signature
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
