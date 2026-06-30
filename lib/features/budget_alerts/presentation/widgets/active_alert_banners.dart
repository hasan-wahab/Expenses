import 'package:expense_app/core/constant/const_text/alart_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActiveAlertBanners extends StatelessWidget {
  const ActiveAlertBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: .start,
      children: [
        SecondaryText(text: AlertScreenText.activeAlert),

        /// 1st Banner
        BannerWidget(isWarning: true),
        BannerWidget(),
      ],
    );
  }
}

class BannerWidget extends StatelessWidget {
  bool isWarning;
  BannerWidget({super.key, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isWarning
            ? AppColors.bannerWarningColor
            : AppColors.bannerYellowColor,
        borderRadius: .circular(12.r),
      ),
      alignment: .center,
      child: Padding(
        padding: .all(16.r),
        child: Row(
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            Icon(
              isWarning ? Icons.warning : Icons.info_outline,
              color: isWarning ? AppColors.redColor : Colors.amber,
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                SecondaryText(text: AlertScreenText.near),
                SizedBox(
                  width: 268.w,
                  child: SmallText(
                    maxLine: 3,
                    text: AlertScreenText.nearBudgetValue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
