import 'package:expense_app/core/constant/const_text/comparison_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalExpenseComparison extends StatelessWidget {
  const TotalExpenseComparison({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .all(16.r),
      decoration: BoxDecoration(
        border: .all(color: AppColors.primary),
        borderRadius: .circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SecondaryText(text: ComparisonScreenText.totalExpenseComparison),
          SizedBox(height: 24.h),

          /// Chart
          SizedBox(
            height: 150.h,
            child: Stack(
              alignment: .bottomCenter,
              children: [
                Column(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                      height: 1,
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                      height: 1,
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                      height: 1,
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                      height: 1,
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                      height: 1,
                    ),
                  ],
                ),
                MyBarChart(),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              SecondaryText(text: ComparisonScreenText.kpkHome),
              SecondaryText(text: ComparisonScreenText.kpkHome),
            ],
          ),
        ],
      ),
    );
  }
}

class MyBarChart extends StatelessWidget {
  const MyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: .end,
        mainAxisAlignment: .spaceEvenly,
        children: [
          /// Bar Chart 1st Rod Column
          Column(
            spacing: 12.h,
            mainAxisAlignment: .end,
            children: [
              /// 1st Bar Chart Value like -> 55.k expense
              SecondaryText(
                text: '30.8k',
                style: context.secondaryText!.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Container(
                height: 100.h,
                width: 66.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: .only(
                    topRight: .circular(12.r),
                    topLeft: .circular(12.r),
                  ),
                ),
              ),
            ],
          ),

          /// Bar Char 2nd Rod Column
          Column(
            mainAxisAlignment: .end,
            spacing: 12.h,
            children: [
              /// 1st Bar Chart Value like -> 55.k expense
              SecondaryText(
                text: ComparisonScreenText.percent,
                style: context.secondaryText!.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Container(
                height: 84.h,
                width: 66.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: .only(
                    topRight: .circular(12.r),
                    topLeft: .circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
