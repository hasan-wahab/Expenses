import 'package:expense_app/core/constant/const_text/personal_information_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleAvatarWidget extends StatelessWidget {
  const CircleAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: .infinity,
      child: Column(
        spacing: 16.h,
        children: [
          SizedBox(
            height: 128.h,
            width: 128.w,
            child: Column(
              children: [
                Stack(
                  alignment: .bottomEnd,
                  children: [
                    Container(
                      height: 128.h,
                      width: 128.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: .circle,
                        border: .all(color: AppColors.primary),
                      ),
                      child: Icon(Icons.person),
                    ),
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        shape: .circle,
                        color: AppColors.primary,
                        border: .all(color: AppColors.white),
                      ),
                      child: Icon(Icons.camera_alt, color: AppColors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ExtraSmallText(text: PersonalInformationText.changeAvatar),
        ],
      ),
    );
  }
}
