import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: .all(24.r),
          child: SizedBox(
            height: .infinity,
            width: .infinity,
            child: Column(
              spacing: 20.h,
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Container(
                  padding: .all(20.r),
                  decoration: BoxDecoration(
                    shape: .circle,
                    border: .all(width: 10.r, color: AppColors.primary),
                  ),
                  child: Icon(
                    Icons.message,
                    color: AppColors.primary,
                    size: 80.r,
                  ),
                ),
                LargeText(text: 'Information'),
                SmallText(
                  align: .center,
                  text:
                      "We couldn't sync your recent expenses.Please check your internet connection and try again.",
                ),

                PrimaryButton(isOutline: true, text: 'Go Back', onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
