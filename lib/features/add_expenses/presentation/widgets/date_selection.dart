import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/extensions/date_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../widgets/small_text.dart';

class DateSelection extends StatelessWidget {
  final VoidCallback onTap;
  String selectedDate;
  DateSelection({
    super.key,
    required this.onTap,
    this.selectedDate = '01/12/2025',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.h,
      crossAxisAlignment: .start,
      children: [
        SmallText(text: AddExpenseText.date),
        InkWell(
          onTap: onTap,
          child: Card(
            child: Container(
              height: 48.h,
              padding: .symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  SmallText(text: selectedDate),
                  Spacer(),
                  Icon(Icons.calendar_month),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
