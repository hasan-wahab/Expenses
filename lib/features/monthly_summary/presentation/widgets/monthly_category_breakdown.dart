import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyCategoryBreakdown extends StatelessWidget {
  const MonthlyCategoryBreakdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(24.r),
      width: .infinity,
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: .circular(12.r),
        border: .all(color: AppColors.primary),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 24.h,
        children: [
          SecondaryText(text: MonthlySummaryText.cateBreakdown),
          ListTileLayout(),
        ],
      ),
    );
  }
}

class ListTileLayout extends StatelessWidget {
  const ListTileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: .only(top: index == 0 ? 0 : 20),
          height: 64.h,
          padding: .all(8.r),
          width: .infinity,
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            border: .all(color: AppColors.primary),
            borderRadius: .circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: .center,
            spacing: 16.w,
            mainAxisAlignment: .spaceBetween,
            children: [
              /// Circle Avatar
              Container(
                height: 48.h,
                width: 48.h,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: AppColors.primary,
                ),
                child: Icon(Icons.gas_meter, color: AppColors.white),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: .spaceAround,
                  children: [
                    /// List Tile Title
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        SmallText(
                          text: MonthlySummaryText.petrol,
                          style: context.smallText!.copyWith(fontWeight: .w500),
                        ),
                        ExtraSmallText(text: 'Rs. 8,540'),
                      ],
                    ),

                    /// Linear Progress Indicator
                    LinearProgressIndicator(
                      color: AppColors.primary,
                      value: 10,
                    ),
                  ],
                ),
              ),

              /// List Tile Trailing
              SmallText(
                text: '15%',
                style: context.smallText!.copyWith(fontWeight: .w500),
              ),
            ],
          ),
        );
      },
    );
  }
}
