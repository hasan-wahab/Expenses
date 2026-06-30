import 'package:expense_app/core/constant/const_text/comparison_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/monthly_summary/presentation/widgets/monthly_dropdown.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/category_wise_comparison.dart';
import '../widgets/comparison_card.dart';
import '../widgets/total_expense_comparison.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: ComparisonScreenText.appBarText,
        actionIcon1: Icons.notifications_none,
        actionIcon2: Icons.menu,
      ),
      body: SafeArea(
        child: ListView(padding: .symmetric(horizontal: 20.w),

        children: [
          SizedBox(height: 16.h,),
          /// Monthly Dropdown for comparison between two properties
          MonthlyDropdown(),
          SizedBox(height: 24.h,),
          /// Comparison Card
          ComparisonCard(),
          SizedBox(height: 24.h,),
          /// Total Expense Comparison
          TotalExpenseComparison(),
          SizedBox(height: 24.h,),
          /// Category Wise Comparison
          CategoryWiseComparison()
        ],
        ),
      ),
    );
  }
}
