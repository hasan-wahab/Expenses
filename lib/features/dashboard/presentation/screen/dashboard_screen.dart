import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/widgets/app_b_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/cusom_appbar.dart';
import '../../../widgets/add_new_floating_btn.dart';
import '../widgets/home_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: DashboardText.appBarText,
        actionIcon1: Icons.notifications_none,
      ),
      body: ListView.builder(
        itemCount: 3,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: Column(
              children: [
                /// Card
                InkWell(
                  onTap: () {
                    context.push(RoutesName.monthlySummary);
                  },
                  child: HomeCard(),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: AddNewFloatingButton(text: DashboardText.addNew),
    );
  }
}
