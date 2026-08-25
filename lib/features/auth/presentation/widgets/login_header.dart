import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/const_text/auth_text.dart';
import '../../../widgets/extra_large_text.dart';
import '../../../widgets/extra_small_text.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 32.h),
      alignment: Alignment.topCenter,
      height: 252.h,
      width: 226.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: .circular(12.r),
            child: Image.asset(
              'assets/images/app_logo.png',
              height: 100.h,
              width: 100.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16.h),
          ExtraLargeText(text: AuthText.welcomeText),
          SizedBox(height: 8.h),
          SizedBox(
            height: 40.h,
            width: 321.w,
            child: ExtraSmallText(
              text: AuthText.pleaseLoginText,
              align: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
