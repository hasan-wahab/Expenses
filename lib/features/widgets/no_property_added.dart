import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoPropertyAdded extends StatelessWidget {
  final VoidCallback onAddTap;

  const NoPropertyAdded({super.key, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.home_work_outlined,
              size: 56.r,
              color: AppColors.primary,
            ),
            SizedBox(height: 20.h),
            SmallText(
              align: TextAlign.center,
              maxLine: 3,
              text: DashboardText.noPropertyAdded,
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              width: double.infinity,
              text: DashboardText.addNew,
              onTap: onAddTap,
            ),
          ],
        ),
      ),
    );
  }
}
