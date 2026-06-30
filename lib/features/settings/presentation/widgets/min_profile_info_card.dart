import 'package:expense_app/core/constant/const_text/settings_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinProfileInfoCard extends StatelessWidget {
  const MinProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: .all(16.r),
        decoration: BoxDecoration(
          borderRadius: .circular(12.r),
          // border: .all(color: AppColors.primary),
        ),
        child: Row(
          spacing: 24.w,
          children: [
            /// Profile Image
            Stack(
              alignment: .bottomEnd,
              children: [
                Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    border: .all(color: AppColors.primary, width: 2),
                    shape: .circle,
                  ),
                  child: Icon(Icons.person),
                ),
                Container(
                  height: 25.h,
                  width: 25.w,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(Icons.edit, color: AppColors.white, size: 15.r),
                ),
              ],
            ),

            /// Info Column
            Column(
              crossAxisAlignment: .start,
              children: [
                SecondaryText(text: SettingsScreenText.name),
                SmallText(text: SettingsScreenText.email),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
