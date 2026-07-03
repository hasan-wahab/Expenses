import 'package:expense_app/core/constant/const_text/currency_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuggestedCurrencies extends StatelessWidget {
  const SuggestedCurrencies({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: .start,
      children: [
        SmallText(text: CurrencyText.suggestCurrency),
        Card(
          child: Column(
            children: [
              CurrenciesListTile(
                leadingIcon: Icons.monetization_on,
                title: CurrencyText.pkr,
                subTitle: CurrencyText.pR,
                isSelected: true,
              ),
              CurrenciesListTile(
                leadingIcon: Icons.monetization_on,
                title: CurrencyText.pkr,
                subTitle: CurrencyText.pR,
                isSelected: false,
              ),
              CurrenciesListTile(
                leadingIcon: Icons.monetization_on,
                title: CurrencyText.pkr,
                subTitle: CurrencyText.pR,
                isSelected: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CurrenciesListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subTitle;
  bool isSelected;

  CurrenciesListTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subTitle,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: .all(16.r),
          decoration: BoxDecoration(borderRadius: .circular(12.r)),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                spacing: 16.w,
                children: [
                  /// Leading
                  Container(
                    padding: .all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: .circle,
                    ),
                    child: Icon(Icons.monetization_on_outlined),
                  ),

                  /// Title Column
                  Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    children: [
                      SecondaryText(text: CurrencyText.pkr),
                      ExtraSmallText(text: CurrencyText.pR),
                    ],
                  ),
                ],
              ),

              Container(
                padding: .all(3.r),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: .circle,
                  border: .all(color: AppColors.primary, width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: .all(5.r),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : null,
                        shape: .circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: AppColors.primary.withOpacity(0.1),
          thickness: 1.h,
          height: 1.h,
        ),
      ],
    );
  }
}
