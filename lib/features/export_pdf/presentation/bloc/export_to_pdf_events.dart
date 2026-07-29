import 'dart:typed_data';

import '../../../../core/constant/enums.dart';

abstract class ExportPdfEvents {}

class ExportToPdfEvent extends ExportPdfEvents {
  final String propertyCardId;
  final String propertyName;
  final String location;
  ExportToPdfMode mode;
  DateTime? startDate;
  DateTime? endDate;
  ExportToPdfEvent({
    required this.propertyCardId,
    required this.mode,
    this.startDate,
    this.endDate,
    required this.propertyName,
    required this.location,
  });
}

class GetAllPropertyCardEvent extends ExportPdfEvents {}

class DownloadPdfEvent extends ExportPdfEvents {
  final String propertyName;
  final Uint8List pdfBytes;
  DownloadPdfEvent({required this.propertyName, required this.pdfBytes});
}
