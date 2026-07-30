import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/themes/themes/colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';
import '../../../widgets/extra_small_text.dart';
import '../../../widgets/small_text.dart';

class CategoryDetailScreen extends StatelessWidget {
  final List<ExpenseEntity> expenses;
  const CategoryDetailScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            '${expenses.first.categoryType.toString().toTitleCase()} Details',
        //title: ' Details',
      ),

      body: ListView.separated(
        padding: .symmetric(horizontal: 20.w),
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return Card(
            margin: .only(top: index == 0 ? 20.h : 0),
            child: ListTile(
              title: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  SecondaryText(
                    text: expenses[index].title.toString().toTitleCase(),
                    style: context.secondaryText!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SmallText(
                    text: 'Rs : ${expenses[index].amount.toString()}',
                    style: context.smallText!.copyWith(
                      color: AppColors.redColor,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: .start,
                children: [
                  SmallText(
                    maxLine: 5,
                    text: expenses[index].note.toString().toSentenceCase(),
                  ),
                  SecondaryText(
                    text: expenses[index].date.toString(),
                    style: context.secondaryText!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: index >= expenses.length - 1 ? 0 : 12);
        },
      ),
    );
  }
}
