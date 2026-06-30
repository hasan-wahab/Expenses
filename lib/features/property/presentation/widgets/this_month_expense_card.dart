import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/const_text/property_screen_text.dart';
import '../../../../core/constant/themes/themes/colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../widgets/extra_small_text.dart';
import '../../../widgets/large_text.dart';
import '../../../widgets/secondery_text.dart';
import '../../../widgets/small_text.dart';

class ThisMonthExpenseCard extends StatelessWidget {
  const ThisMonthExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(24.r),
      width: .infinity,
      decoration: BoxDecoration(
        border: .all(color: AppColors.primary),
        borderRadius: .circular(12.r),
      ),
      child: Column(
        spacing: 16.h,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  SmallText(text: PropertyScreenText.thisMonth),
                  LargeText(text: PropertyScreenText.thisMonthExpenseValue),
                ],
              ),
              Column(
                mainAxisSize: .min,
                crossAxisAlignment: .end,
                children: [
                  ExtraSmallText(text: PropertyScreenText.budget),
                  SecondaryText(
                    text: PropertyScreenText.percentage,
                    style: context.secondaryText!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          LinearProgressIndicator(
            minHeight: 12.h,
            backgroundColor: AppColors.white,

            value: 0.6,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            borderRadius: .circular(10.r),
          ),
        ],
      ),
    );
  }
}
