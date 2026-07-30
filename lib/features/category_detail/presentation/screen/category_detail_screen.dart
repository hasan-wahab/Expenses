import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/category_detail/presentation/widgets/expense_list_card.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/themes/themes/colors.dart';
import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';

class CategoryDetailScreen extends StatelessWidget {
  final List<ExpenseEntity> expenses;
  const CategoryDetailScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title:
            '${expenses.first.categoryType.toString().toTitleCase()} Details',
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            return ExpenseListCard(
              expense: expenses[index],
              isFirst: index == 0,
              onTap: () {
                context.push(
                  RoutesName.expenseDetailScreen,
                  extra: expenses[index],
                );
              },
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: index >= expenses.length - 1 ? 0 : 12.h);
          },
        ),
      ),
    );
  }
}
