import 'package:expense_app/core/constant/const_text/currency_text.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/suggested_correncies.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: CurrencyText.appBarText),
      body: ListView(
        padding: .symmetric(horizontal: 20.w),
        children: [
          SizedBox(height: 24.h),

          /// Search Currency
          AppTField(hintText: CurrencyText.searchText, startIcon: Icons.search),
          SizedBox(height: 24.h),

          /// SUGGESTED CURRENCIES
          SuggestedCurrencies(),
        ],
      ),
    );
  }
}
