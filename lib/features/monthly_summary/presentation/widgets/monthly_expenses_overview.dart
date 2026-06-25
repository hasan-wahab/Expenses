import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyExpensesOverview extends StatelessWidget {
  const MonthlyExpensesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(24.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: .circular(12.r),
        border: .all(color: AppColors.primary),
      ),
      child: Column(
        spacing: 24.h,
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              SecondaryText(text: MonthlySummaryText.overview),
              SmallText(
                text: MonthlySummaryText.pastFiveMonth,
                style: context.smallText!.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          CharLayoutBuilder(),
        ],
      ),
    );
  }
}

class CharLayoutBuilder extends StatelessWidget {
  const CharLayoutBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Row(
            crossAxisAlignment: .end,
            mainAxisAlignment: .spaceBetween,
            spacing: 20.w,
            children: List.generate((5), (index) {
              final width = (constraint.maxWidth - 100) / 5;
              return Column(
                mainAxisSize: .min,
                spacing: 8.h,
                children: [
                  Container(
                    height: index == 4 ? 50.h : 20,
                    width: width,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: .only(
                        topRight: .circular(12.r),
                        topLeft: .circular(12.r),
                      ),
                    ),
                  ),
                  SmallText(text: 'Jan'),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
