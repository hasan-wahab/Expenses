import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/monthly_summary/presentation/widgets/monthly_expenses_overview.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/monthly_category_breakdown.dart';
import '../widgets/monthly_dropdown.dart';
import '../widgets/monthly_total_expense_card.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({super.key});

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: MonthlySummaryText.monthlyAppBar,
        leadingOnTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0));
          }
        },
        actionIcon1: Icons.calendar_month,

        actionIcon1Ontap: () {
          showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now(),
          );
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (context.canPop()) {
            context.pop();
          } else {
            context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0));
          }
          return false;
        },
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            SizedBox(height: 16.h),

            /// DropDowns Button
            MonthlyDropdown(),
            SizedBox(height: 24.h),

            /// Total Expenses Card
            MonthlyTotalExpenseCard(),
            SizedBox(height: 24.h),

            /// Expenses Overview
            MonthlyExpensesOverview(),
            SizedBox(height: 24.h),

            /// Category Breakdown
            MonthlyCategoryBreakdown(),
          ],
        ),
      ),
    );
  }
}
