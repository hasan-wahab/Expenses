import 'package:expense_app/core/constant/const_text/export_pdf_text.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: .all(16.r),
        child: Column(
          spacing: 5.h,
          crossAxisAlignment: .start,
          children: [
            SecondaryText(text: ExportPdfText.export),
            ExtraSmallText(maxLine: 3, text: ExportPdfText.exportSubTitle),
          ],
        ),
      ),
    );
  }
}
