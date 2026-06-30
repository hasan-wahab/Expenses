import 'package:expense_app/core/constant/const_text/comparison_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComparisonCard extends StatelessWidget {
  const ComparisonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: Container(
            padding: .all(16.r),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 5,
                colors: [
                  AppColors.primary.withOpacity(0.5),
                  AppColors.primaryDark,
                  AppColors.primaryDark,
                ],
              ),
              borderRadius: .circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                /// Image Circle Avatar
                Container(
                  height: 56.h,
                  width: 56.w,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: AppColors.bgColor,
                    border: .all(color: AppColors.white),
                  ),
                  child: ClipRRect(child: Icon(Icons.image, size: 30.r)),
                ),
                SizedBox(height: 8.h),

                /// Home Name
                SmallText(
                  text: ComparisonScreenText.kpkHome,
                  style: context.smallText!.copyWith(color: AppColors.white),
                ),
                SizedBox(height: 4.h),

                /// Expense
                SecondaryText(
                  text: ComparisonScreenText.rs,
                  style: context.secondaryText!.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: .all(16.r),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 5,
                colors: [
                  AppColors.primary.withOpacity(0.5),
                  AppColors.primaryDark,
                  AppColors.primaryDark,
                ],
              ),
              borderRadius: .circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                /// Image Circle Avatar
                Container(
                  height: 56.h,
                  width: 56.w,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: AppColors.bgColor,
                    border: .all(color: AppColors.white),
                  ),
                  child: ClipRRect(child: Icon(Icons.image, size: 30.r)),
                ),
                SizedBox(height: 8.h),

                /// Home Name
                SmallText(
                  text: ComparisonScreenText.kpkHome,
                  style: context.smallText!.copyWith(color: AppColors.white),
                ),
                SizedBox(height: 4.h),

                /// Expense
                SecondaryText(
                  text: ComparisonScreenText.rs,
                  style: context.secondaryText!.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
