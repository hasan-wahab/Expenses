import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_expenses/presentation/widgets/add_expense_category.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/upload_receipt_image.dart';

class AddExpensesScreen extends StatelessWidget {
  const AddExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: AddExpenseText.addExpenseText),
      body: ListView(
        padding: .symmetric(horizontal: 20.w),
        children: [
          /// Enter Amount Field
          AppTField(
            hintText: AddExpenseText.enterAmount,
            labelText: AddExpenseText.amount,
            startIcon: Icons.monetization_on,
          ),
          SizedBox(height: 24.h),

          /// Chose Category
          AddExpenseCategory(),
          SizedBox(height: 24.h),

          /// Date Field
          AppTField(
            hintText: '23/05/2024',
            labelText: AddExpenseText.date,
            endIcon: Icons.calendar_today,
          ),
          SizedBox(height: 24.h),

          /// Notes Field --> Optional
          AppTField(
            isExtended: true,
            hintText: AddExpenseText.addHere,
            labelText: AddExpenseText.notes,
          ),

          SizedBox(height: 24.h),

          /// Upload Receipt Image
          UploadReceiptImage(),
          SizedBox(height: 24.h),

          /// Save Expense Button
          PrimaryButton(text: AddExpenseText.saveExpense, onTap: () {
            context.push(RoutesName.comparisonScreen);
          }),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
