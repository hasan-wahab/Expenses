import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/themes/themes/colors.dart';

class CategoryDropdown extends StatelessWidget {
  final Function(String)? onChange;
  ValueNotifier? selectedItem;
  String initialValue;
  CategoryDropdown({
    super.key,
    this.onChange,
    this.selectedItem,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    selectedItem = ValueNotifier<String?>(null);
    return Column(
      spacing: 5.h,
      crossAxisAlignment: .start,
      children: [
        ExtraSmallText(text: 'Category Type'),
        Card(
          child: DropdownButton2(
            underline: SizedBox(),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: .circular(12.r),
                color: AppColors.bgColor,
                //border: .all(color: AppColors.primary),
              ),
            ),
            isExpanded: true,
            hint: Text(initialValue != '' ? initialValue : 'Select Item'),
            valueListenable: selectedItem,
            items: [
              DropdownItem(value: 'Home', child: Text('Home')),
              DropdownItem(value: 'Business', child: Text('Business')),
              DropdownItem(value: 'Apartment', child: Text('Apartment')),
              DropdownItem(value: 'Shop', child: Text('Shop')),
              DropdownItem(value: 'Office', child: Text('Office')),
              DropdownItem(value: 'Warehouse', child: Text('Warehouse')),
              DropdownItem(value: 'Villa', child: Text('Villa')),
              DropdownItem(value: 'Farmhouse', child: Text('Farmhouse')),
              DropdownItem(value: 'Plot', child: Text('Plot')),
              DropdownItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) {
              selectedItem?.value = value;
              onChange!(selectedItem!.value!);
            },
          ),
        ),
      ],
    );
  }
}
