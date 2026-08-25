import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/themes/themes/colors.dart';
import '../../../../core/extensions/context_extension.dart';

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
            hint: Text(initialValue != '' ? initialValue : 'Select Category'),
            valueListenable: selectedItem,
            items: [
              DropdownItem(
                value: 'Home',
                child: Text('Home', style: context.smallText),
              ),
              DropdownItem(
                value: 'Business',
                child: Text('Business', style: context.smallText),
              ),
              DropdownItem(
                value: 'Apartment',
                child: Text('Apartment', style: context.smallText),
              ),
              DropdownItem(
                value: 'Shop',
                child: Text('Shop', style: context.smallText),
              ),
              DropdownItem(
                value: 'Office',
                child: Text('Office', style: context.smallText),
              ),
              DropdownItem(
                value: 'Warehouse',
                child: Text('Warehouse', style: context.smallText),
              ),
              DropdownItem(
                value: 'Villa',
                child: Text('Villa', style: context.smallText),
              ),
              DropdownItem(
                value: 'Farmhouse',
                child: Text('Farmhouse', style: context.smallText),
              ),
              DropdownItem(
                value: 'Plot',
                child: Text('Plot', style: context.smallText),
              ),
              DropdownItem(
                value: 'Other',
                child: Text('Other', style: context.smallText),
              ),
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
