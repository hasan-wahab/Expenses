import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetDropDown extends StatefulWidget {
  final ValueNotifier valueNotifier;
  const BudgetDropDown({super.key, required this.valueNotifier});

  @override
  State<BudgetDropDown> createState() => _BudgetDropDownState();
}

class _BudgetDropDownState extends State<BudgetDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      underline: SizedBox(),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          border: .all(color: AppColors.primary),
          boxShadow: [BoxShadow(color: AppColors.bgColor)],
          borderRadius: .circular(12.r),
        ),
      ),
      buttonStyleData: ButtonStyleData(
        decoration: BoxDecoration(
          borderRadius: .circular(12.r),
          color: AppColors.bgColor,
          border: .all(color: AppColors.primary),
        ),
      ),
      isExpanded: true,
      hint: Text('Select Item'),
      valueListenable: widget.valueNotifier,
      items: [
        DropdownItem(value: 'data 0', child: Text('data 0')),
        DropdownItem(value: 'data 1', child: Text('data 1')),
        DropdownItem(value: 'data 2', child: Text('data 2')),
        DropdownItem(value: 'data 3', child: Text('data 3')),
        DropdownItem(value: 'data 4', child: Text('data 4')),
        DropdownItem(value: 'data 5', child: Text('data 5')),
      ],
      onChanged: (value) {
        widget.valueNotifier.value = value;
      },
    );
  }
}
