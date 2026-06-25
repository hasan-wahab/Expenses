import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/widgets/app_b_text.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 218.h,
      width: 350.w,
      child: Card(
        surfaceTintColor: AppColors.primaryDark,
        borderOnForeground: true,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.iconsColor,
        color: AppColors.bgColor,
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisAlignment: .spaceBetween,
            children: [
              /// Card Header
              SizedBox(
                width: double.infinity,
                height: 80.h,
                child: Row(
                  spacing: 16.w,
                  children: [
                    /// Image Container
                    SizedBox(
                      height: 80.h,
                      width: 80.w,
                      child: Card(
                        surfaceTintColor: AppColors.primaryDark,
                        borderOnForeground: true,
                        margin: EdgeInsets.zero,
                        shadowColor: AppColors.iconsColor,
                        color: AppColors.bgColor,
                        child: Icon(Icons.photo, size: 40.r),
                      ),
                    ),

                    /// Name And Location Name
                    Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .start,

                      children: [
                        SecondaryText(text: DashboardText.homeLocationName),
                        Row(
                          mainAxisAlignment: .start,
                          mainAxisSize: .min,
                          children: [
                            Icon(Icons.location_on_outlined),
                            SmallText(text: DashboardText.homeName),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Card Footer
              SizedBox(
                height: 88.h,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .start,
                  children: [
                    /// This month expenses and Budget
                    SmallText(text: DashboardText.thisMonthExpense),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        SecondaryText(
                          text: 'Rs. 28,540',
                          style: context.secondaryText!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        SmallText(text: DashboardText.budget),
                      ],
                    ),

                    /// Budget progress
                    LinearProgressIndicator(
                      minHeight: 12.h,
                      backgroundColor: AppColors.white,

                      value: 0.6,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      borderRadius: .circular(10.r),
                    ),
                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        SmallText(
                          text: '71%',
                          style: context.smallText!.copyWith(
                            color: AppColors.primary,
                            fontWeight: .bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
