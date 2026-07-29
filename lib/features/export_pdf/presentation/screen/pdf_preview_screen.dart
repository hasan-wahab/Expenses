import 'dart:async';
import 'dart:typed_data';

import 'package:expense_app/core/constant/const_text/export_pdf_text.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/utils/downloads_saver.dart';
import 'package:expense_app/core/utils/property_report_pdf_builder.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/di/get_it.dart';
import '../bloc/export_to_pdf_bloc.dart';
import '../bloc/export_to_pdf_events.dart';
import '../bloc/export_to_pdf_states.dart';

// /// Args for PDF preview screen.
// class PdfPreviewArgs {
//   const PdfPreviewArgs({
//     required this.propertyName,
//     required this.location,
//     required this.totalExpenses,
//     required this.reportingPeriod,
//     this.expenses = const [],
//   });
//
//   final String propertyName;
//   final String location;
//   final String totalExpenses;
//   final String reportingPeriod;
//   final List<PdfExpenseItem> expenses;
// }

/// Shows the real generated PDF (not just design widgets).
class PdfPreviewScreen extends StatefulWidget {
  FutureOr<Uint8List> Function(PdfPageFormat) build;
  String propertyName;

  PdfPreviewScreen({
    super.key,
    required this.build,
    required this.propertyName,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExportToPdfBloc>(),
      child: BlocConsumer<ExportToPdfBloc, ExportToPdfStates>(
        listener: (context, state) {
          if (state is DownloadPdfState) {
            switch (state.status) {
              case Status.loading:
                context.showCustomLoading();
                break;
              case Status.success:
                context.pop();
                context.showSnackBar(state.message);
                break;
              case Status.error:
                context.pop();
                context.showSnackBar(state.message, isError: true);
                break;
              case Status.initial:
                // TODO: Handle this case.
                throw UnimplementedError();
              case Status.message:
                // TODO: Handle this case.
                throw UnimplementedError();
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: CustomAppBar(title: 'PDF Preview', isLeading: true),
            body: Column(
              children: [
                Expanded(
                  child: PdfPreview(
                    build: widget.build,
                    initialPageFormat: PdfPageFormat.a4,
                    allowPrinting: false,
                    allowSharing: false,
                    canChangePageFormat: false,
                    canChangeOrientation: false,
                    canDebug: false,
                    useActions: false,
                    pdfFileName: '${widget.propertyName}.pdf',
                    loadingWidget: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    onError: (context, error) => Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Text(
                          'PDF preview failed.\nPlease Stop app and Run again.\n\n$error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
                    child: PrimaryButton(
                      text: ExportPdfText.download,
                      onTap: () async {
                        context.read<ExportToPdfBloc>().add(
                          DownloadPdfEvent(
                            propertyName: '${widget.propertyName}/Property.pdf',
                            pdfBytes: await widget.build(PdfPageFormat.a4),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
