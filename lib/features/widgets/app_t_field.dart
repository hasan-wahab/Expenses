import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/string_extension.dart';
import 'small_text.dart';

class AppTField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  final IconData? startIcon;
  final IconData? endIcon;
  final String? Function(String?)? validator;
  bool isExtended;
  AppTField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.controller,
    this.startIcon,
    this.endIcon,
    this.validator,
    this.isExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.h,
      crossAxisAlignment: .start,
      children: [
        ExtraSmallText(text: labelText.toTitleCase()),
        SizedBox(
          height: isExtended ? 86.h : 48.h,
          width: 350.w,
          child: CupertinoTextField.borderless(
            padding: isExtended
                ? .only(left: 10.w, top: 10.h)
                : .only(left: 10.w),
            suffix: endIcon != null
                ? Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Icon(endIcon),
                  )
                : null,
            prefix: startIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Icon(startIcon),
                  )
                : null,
            controller: controller,

            placeholder: hintText,

            textAlignVertical: isExtended
                ? TextAlignVertical.top
                : TextAlignVertical.center,
            textAlign: .left,
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: .circular(12.r),
              border: Border.all(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
