import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes_name.dart';
import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';
import '../../domain/entitity/summary_entity_model.dart';

class MonthlyCategoryBreakdown extends StatelessWidget {
  List<ExpenseEntity> expensesList;
  List<CategoryBreakdownEntityModel> categoryBreakdown;
  MonthlyCategoryBreakdown({
    super.key,
    required this.categoryBreakdown,
    required this.expensesList,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: .all(24.r),
        width: .infinity,

        child: Column(
          crossAxisAlignment: .start,
          spacing: 24.h,
          children: [
            SecondaryText(text: MonthlySummaryText.cateBreakdown),
            ListTileLayout(
              categoryBreakdown: categoryBreakdown,
              expensesList: expensesList,
            ),
          ],
        ),
      ),
    );
  }
}

class ListTileLayout extends StatelessWidget {
  final List<ExpenseEntity> expensesList;
  final List<CategoryBreakdownEntityModel> categoryBreakdown;
  const ListTileLayout({
    super.key,
    required this.categoryBreakdown,
    required this.expensesList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      itemCount: categoryBreakdown.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            List<ExpenseEntity> expenses = [];
            for (var item in expensesList) {
              if (item.categoryType == categoryBreakdown[index].categoryName) {
                expenses.add(item);
              }
            }
            context.push(RoutesName.categoryDetailScreen, extra: expenses);
          },
          child: Card(
            child: Container(
              height: 64.h,
              padding: .all(8.r),
              width: .infinity,
              child: Row(
                crossAxisAlignment: .center,
                spacing: 16.w,
                mainAxisAlignment: .spaceBetween,
                children: [
                  /// Circle Avatar
                  Container(
                    alignment: .center,
                    height: 48.h,
                    width: 48.h,
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: AppColors.primary,
                    ),
                    child: SmallText(
                      text: '${categoryBreakdown[index].progress.toInt()}%',
                      style: context.smallText!.copyWith(
                        fontWeight: .w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        /// List Tile Title
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            SmallText(
                              text: categoryBreakdown[index].categoryName
                                  .toTitleCase(),
                              style: context.smallText!.copyWith(
                                fontWeight: .w500,
                              ),
                            ),
                            ExtraSmallText(
                              text:
                                  'Rs. ${categoryBreakdown[index].totalAmount}',
                            ),
                          ],
                        ),

                        /// Linear Progress Indicator
                        LinearProgressIndicator(
                          color: AppColors.primary,
                          value: categoryBreakdown[index].progress / 100,
                        ),
                      ],
                    ),
                  ),

                  /// List Tile Trailing
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: index == categoryBreakdown.length - 1 ? 0.h : 12.h,
        );
      },
    );
  }
}
