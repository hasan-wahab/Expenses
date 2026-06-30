import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/const_text/alart_screen_text.dart';
import '../../../../core/constant/themes/themes/colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../widgets/large_text.dart';
import '../../../widgets/secondery_text.dart';
import '../../../widgets/small_text.dart';

class MonthlyBudgetCard extends StatelessWidget {
  const MonthlyBudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: .all(16.r),
      decoration: BoxDecoration(
        border: .all(color: AppColors.primary),
        borderRadius: .circular(12.r),
      ),
      child: Column(
        spacing: 16.h,
        children: [
          /// Monthly budget 1st Row
          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .start,
            children: [
              Column(
                children: [
                  SmallText(text: AlertScreenText.monthlyBudget),

                  LargeText(text: AlertScreenText.monthlyBudgetValue),
                ],
              ),
              SecondaryText(
                text: AlertScreenText.edit,
                style: context.secondaryText!.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          /// Monthly budget 2nd Column
          Column(
            spacing: 8.h,
            crossAxisAlignment: .start,
            children: [
              Row(
                crossAxisAlignment: .end,
                mainAxisAlignment: .spaceBetween,
                children: [
                  SmallText(text: AlertScreenText.spent),
                  SecondaryText(
                    text: AlertScreenText.percent,
                    style: context.secondaryText!.copyWith(
                      color: AppColors.primary,
                    ),
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
              SmallText(text: AlertScreenText.remaining),
            ],
          ),
        ],
      ),
    );
  }
}
