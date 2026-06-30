import 'package:expense_app/core/constant/const_text/export_pdf_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: .all(16.r),
        child: Row(
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          spacing: 16.w,

          children: [
            Container(
              height: 64.h,
              width: 64.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: .circular(12.r),
              ),
              child: Icon(Icons.image, color: AppColors.white),
            ),
            Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                SecondaryText(text: ExportPdfText.preview),
                SizedBox(
                  width: 222.2.w,
                  child: ExtraSmallText(
                    maxLine: 2,
                    text: ExportPdfText.previewSubTitle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
