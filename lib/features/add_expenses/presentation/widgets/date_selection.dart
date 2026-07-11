import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/extensions/date_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../widgets/small_text.dart';

class DateSelection extends StatefulWidget {
  const DateSelection({super.key});

  @override
  State<DateSelection> createState() => _DateSelectionState();
}

class _DateSelectionState extends State<DateSelection> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.h,
      crossAxisAlignment: .start,
      children: [
        SmallText(text: AddExpenseText.date),
        InkWell(
          onTap: () async {
            selectedDate = await context.showAppDatePicker();
            setState(() {});
          },
          child: Card(
            child: Container(
              height: 48.h,
              padding: .symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  SmallText(
                    text: selectedDate != null
                        ? selectedDate!.toDisplayDate()
                        : '01/12/2025',
                  ),
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
