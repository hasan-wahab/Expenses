import 'package:expense_app/core/constant/const_text/alart_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/active_alert_banners.dart';
import '../widgets/budget_drop_down.dart';
import '../widgets/monthly_budget_card.dart';
import '../widgets/set_monthly_budget.dart';

class BudgetsAlertsScreen extends StatelessWidget {
  const BudgetsAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier selectedItem = ValueNotifier<String?>(null);
    return Scaffold(
      appBar: CustomAppBar(
        title: AlertScreenText.appBarText,
        actionIcon1: Icons.notifications,
      ),
      body: ListView(
        padding: .symmetric(horizontal: 20.w),
        children: [
          SizedBox(height: 24.h),

          /// Drop Down Button
          BudgetDropDown(valueNotifier: selectedItem),
          SizedBox(height: 24.h),

          /// Monthly Budget Card
          MonthlyBudgetCard(),
          SizedBox(height: 24.h),

          /// Active Alert Banners
          ActiveAlertBanners(),
          SizedBox(height: 24.h),

          /// Set Monthly Budget
          SetMonthlyBudget(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
