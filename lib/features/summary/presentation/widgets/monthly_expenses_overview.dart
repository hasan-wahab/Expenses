import 'package:expense_app/core/constant/app_currency.dart';
import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/extra_large_text.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../domain/entitity/summary_entity_model.dart';

class MonthlyExpensesOverview extends StatelessWidget {
  List<MonthlyExpense> monthlyExpense = [];
  MonthlyExpensesOverview({super.key, required this.monthlyExpense});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: .all(24.r),
        width: double.infinity,

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
            CharLayoutBuilder(monthlyExpense: monthlyExpense),
          ],
        ),
      ),
    );
  }
}

class CharLayoutBuilder extends StatelessWidget {
  final List<MonthlyExpense> monthlyExpense;

  const CharLayoutBuilder({super.key, required this.monthlyExpense});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraint) {
          /// 🔥 Step 1: Last 5 months generate
          final now = DateTime.now();

          final last5Months = List.generate(5, (index) {
            final date = DateTime(now.year, now.month - (4 - index));
            return DateFormat.MMM().format(date);
          });

          /// 🔥 Step 2: Convert existing data to map
          final expenseMap = {for (var e in monthlyExpense) e.month: e.amount};

          /// 🔥 Step 3: Final data (missing = 0)
          final finalData = last5Months.map((month) {
            return MonthlyExpense(
              month: month,
              amount: expenseMap[month] ?? 0.0,
            );
          }).toList();

          /// 🔥 Step 4: Max for scaling
          final maxAmount = finalData.isEmpty
              ? 0
              : finalData.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

          final width = (constraint.maxWidth - 40) / 5;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final data = finalData[index];

              double barHeight = maxAmount == 0
                  ? 5
                  : (data.amount / maxAmount) * 150;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExtraSmallText(text: AppCurrency.format(data.amount)),
                  SizedBox(height: 6.h),
                  Container(
                    height: barHeight < 5 ? 5 : barHeight, // 🔥 min height
                    width: width,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: .only(
                        topRight: .circular(12.r),
                        topLeft: .circular(12.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  SmallText(text: data.month),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
