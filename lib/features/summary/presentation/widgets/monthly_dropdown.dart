import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/themes/themes/colors.dart';

class MonthlyDropdown extends StatelessWidget {
  const MonthlyDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier selectedItem = ValueNotifier<String?>(null);
    ValueNotifier selectedItem2 = ValueNotifier<String?>(null);
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: DropdownButton2(
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
            valueListenable: selectedItem,
            items: [
              DropdownItem(value: 'data 0', child: Text('data 0')),
              DropdownItem(value: 'data 1', child: Text('data 1')),
              DropdownItem(value: 'data 2', child: Text('data 2')),
              DropdownItem(value: 'data 3', child: Text('data 3')),
              DropdownItem(value: 'data 4', child: Text('data 4')),
              DropdownItem(value: 'data 5', child: Text('data 5')),
            ],
            onChanged: (value) {
              selectedItem.value = value;
            },
          ),
        ),
        Expanded(
          child: DropdownButton2(
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
            valueListenable: selectedItem2,
            items: [
              DropdownItem(value: 'data 0', child: Text('data 0')),
              DropdownItem(value: 'data 1', child: Text('data 1')),
              DropdownItem(value: 'data 2', child: Text('data 2')),
              DropdownItem(value: 'data 3', child: Text('data 3')),
              DropdownItem(value: 'data 4', child: Text('data 4')),
              DropdownItem(value: 'data 5', child: Text('data 5')),
              DropdownItem(value: 'data 5', child: Text('data 5')),
              DropdownItem(value: 'data 5', child: Text('data 5')),
              DropdownItem(value: 'data 5', child: Text('data 5')),
              DropdownItem(value: 'data 5', child: Text('data 5')),
            ],
            onChanged: (value) {
              selectedItem2.value = value;
            },
          ),
        ),
      ],
    );
  }
}
