import 'package:expense_app/core/constant/const_text/export_pdf_text.dart';
import 'package:expense_app/features/export_pdf/presentation/widgets/selection_period_card.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/header_card.dart';
import '../widgets/preview_card.dart';

class ExportToPdfScreen extends StatelessWidget {
  const ExportToPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ExportPdfText.export),
      body: ListView(
        padding: .symmetric(horizontal: 20.w),
        children: [
          SizedBox(height: 24.h),

          /// message for info
          HeaderCard(),
          SizedBox(height: 24.h),

          /// Select Period Card
          SelectionPeriodCard(),
          SizedBox(height: 24.h),

          /// Export Formate
          PrimaryButton(text: 'Export to PDF', onTap: () {}),
          SizedBox(height: 24.h),

          /// Preview Of Exported PDF Reports
          PreviewCard(),
          SizedBox(height: 30.h),
          PrimaryButton(text: ExportPdfText.download, onTap: () {}),
        ],
      ),
    );
  }
}
