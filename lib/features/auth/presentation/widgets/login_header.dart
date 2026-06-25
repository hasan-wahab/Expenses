import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/const_text/auth_text.dart';
import '../../../../core/constant/themes/themes/colors.dart';
import '../../../widgets/extra_large_text.dart';
import '../../../widgets/extra_small_text.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 32.h),
      alignment: .topCenter,
      height: 252.h,
      width: 226.w,
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Container(
            height: 88.h,
            width: 88.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.home, size: 36.r,color:AppColors.white,),
          ),
          SizedBox(height: 24.h),
          ExtraLargeText(text: AuthText.welcomeText,),
          SizedBox(height: 8.h),
          SizedBox(
            height: 40.h,
            width: 321.w,
            child: ExtraSmallText(
              text: AuthText.pleaseLoginText,
              align: .center,
            ),
          ),
        ],
      ),
    );
  }
}
