import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_large_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.body,
    required this.illustration,
  });

  final String title;
  final String body;
  final Widget illustration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Expanded(flex: 5, child: Center(child: illustration)),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                ExtraLargeText(
                  text: title,
                  align: TextAlign.center,
                  maxLine: 3,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 12.h),
                SmallText(
                  text: body,
                  align: TextAlign.center,
                  maxLine: 4,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.secondaryTColor,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
