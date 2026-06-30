import 'package:expense_app/core/constant/const_text/comparison_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryWiseComparison extends StatelessWidget {
  const CategoryWiseComparison({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16.r),
      decoration: BoxDecoration(
        borderRadius: .circular(12.r),
        border: .all(color: AppColors.primary),
      ),
      child: Column(
        children: [
          /// Category Wise Row Text
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              SecondaryText(
                align: .center,

                text: ComparisonScreenText.categoryWise,
              ),
              Container(
                padding: .all(8.r),
                decoration: BoxDecoration(
                  border: .all(color: AppColors.primary),
                  borderRadius: .circular(20.r),
                ),
                child: ExtraSmallText(
                  align: .center,

                  text: ComparisonScreenText.difference,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          /// ListTile
          Column(
            spacing: 24.h,
            children: [
              CategoryWiseListTileWidget(),
              CategoryWiseListTileWidget(),
              CategoryWiseListTileWidget(),
              CategoryWiseListTileWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryWiseListTileWidget extends StatelessWidget {
  const CategoryWiseListTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Row(
          spacing: 12.w,
          children: [
            CircleAvatar(radius: 18.r),
            SizedBox(
              width: 70.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),

                child: SecondaryText(
                  align: .center,
                  text: ComparisonScreenText.electric,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),

                      child: ExtraSmallText(
                        align: .center,

                        text: ComparisonScreenText.kpkHome,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),

                      child: SmallText(
                        align: .center,

                        text: ComparisonScreenText.cateRs,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),

                      child: ExtraSmallText(
                        align: .center,
                        text: ComparisonScreenText.kpkHome,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: SmallText(
                        align: .center,

                        text: ComparisonScreenText.cateRs,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: SmallText(
                    align: .center,
                    text: ComparisonScreenText.catePercent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
