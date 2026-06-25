import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_large_text.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InternetStatusScreen extends StatelessWidget {
  const InternetStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: .all(44.r),
          child: Column(
            spacing: 20.h,
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              /// Wi Fi Image
              Container(
                padding: .all(15.r),
                decoration: BoxDecoration(
                  shape: .circle,
                  border: .all(
                    color: AppColors.redColor.withOpacity(0.4),
                    width: 10.r,
                  ),
                ),
                child: Icon(
                  Icons.wifi_off_outlined,
                  size: 100.h,
                  color: AppColors.redColor.withOpacity(0.4),
                ),
              ),
              Column(
                spacing: 10.h,
                children: [
                  LargeText(text: 'Connection Lost'),
                  ExtraSmallText(
                    align: .center,
                    text:
                        "We couldn't sync your recent expenses.Please check your internet connectionand try again.",
                  ),
                ],
              ),
              PrimaryButton(isOutline: true, text: 'Try Again', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
