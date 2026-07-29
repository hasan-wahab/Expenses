import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/extra_large_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyTotalExpenseCard extends StatelessWidget {
  final double totalExpense;
  const MonthlyTotalExpenseCard({super.key, required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 110.h,
        width: .infinity,
        // decoration: BoxDecoration(
        //   border: .all(color: Colors.transparent),
        //   borderRadius: .circular(12.r),
        // ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: .only(
                    bottomLeft: .circular(12.r),
                    topLeft: .circular(12.r),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 40,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: .center,

                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: .only(
                    bottomRight: .circular(12.r),
                    topRight: .circular(12.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    SmallText(text: MonthlySummaryText.totalExpense),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        ExtraLargeText(text: totalExpense.toString()),
                        // Container(
                        //   height: 22.h,
                        //   padding: .symmetric(horizontal: 8.r),
                        //   decoration: BoxDecoration(
                        //     borderRadius: .circular(20.r),
                        //     color: AppColors.redColor.withAlpha(10),
                        //   ),
                        //   child: SmallText(
                        //     text: MonthlySummaryText.percentRed,
                        //     style: context.smallText!.copyWith(
                        //       color: AppColors.redColor,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
