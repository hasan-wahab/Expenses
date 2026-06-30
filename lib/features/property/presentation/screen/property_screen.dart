import 'package:expense_app/core/constant/const_text/property_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/property/presentation/widgets/expense_by_category.dart';
import 'package:expense_app/features/property/presentation/widgets/this_month_expense_card.dart';
import 'package:expense_app/features/widgets/add_new_floating_btn.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/extra_large_text.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/recent_transactions.dart';

class PropertyScreen extends StatelessWidget {
  const PropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: PropertyScreenText.propertyAppBarText,
        actionIcon1: Icons.calendar_today,
      ),

      body: ListView(
        padding: .symmetric(horizontal: 20.w),
        children: [
          SizedBox(height: 8.h),

          /// This Month Expense Card
          ThisMonthExpenseCard(),
          SizedBox(height: 24.h),

          /// Expenses by Category Chart Widget
          ExpenseByCategoryChart(),
          SizedBox(height: 24.h),

          /// Recent Transection History
          RecentTransactions(),
          SizedBox(height: 30.h),
        ],
      ),
      floatingActionButton: AddNewFloatingButton(
        text: 'Add Expenses',
        onTap: () {},
      ),
    );
  }
}
