import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/const_text/add_expese_text.dart';
import '../../../../core/constant/themes/themes/colors.dart';
import '../../../widgets/secondery_text.dart';
import '../../../widgets/small_text.dart';

class UploadReceiptImage extends StatelessWidget {
  const UploadReceiptImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: .infinity,
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: .start,
        children: [
          SmallText(text: AddExpenseText.uploadReceipt),
          Container(
            height: 167.h,
            width: .infinity,
            decoration: BoxDecoration(
              borderRadius: .circular(16.r),
              border: .all(color: AppColors.primary),
            ),
            child: Column(
              mainAxisAlignment: .center,
              mainAxisSize: .min,
              children: [
                Icon(Icons.image),
                SecondaryText(text: AddExpenseText.choseImage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
