import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/string_extension.dart';
import 'small_text.dart';

class AppTField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final IconData? startIcon;
  /// e.g. "PKR" instead of dollar icon
  final String? startText;
  final IconData? endIcon;
  final VoidCallback? endIconOnTap;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  bool isExtended;
  bool isObscure;
  TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  AppTField({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.startIcon,
    this.startText,
    this.endIcon,
    this.validator,
    this.isExtended = false,
    this.endIconOnTap,
    this.isObscure = false,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.enabled = true,
  });

  Widget? get _prefix {
    if (startText != null && startText!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: 16.w, right: 4.w),
        child: Text(
          startText!,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            fontSize: 14.sp,
          ),
        ),
      );
    }
    if (startIcon != null) {
      return Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Icon(startIcon),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText != null
            ? ExtraSmallText(text: labelText!.toTitleCase())
            : Container(),
        Card(
          child: SizedBox(
            height: isExtended ? 86.h : 48.h,
            width: 350.w,
            child: CupertinoTextField.borderless(
              onChanged: onChanged,
              focusNode: focusNode,
              enabled: enabled,
              keyboardType: keyboardType,
              obscureText: isObscure,
              padding: isExtended
                  ? EdgeInsets.only(left: 10.w, top: 10.h)
                  : EdgeInsets.only(left: 10.w),
              suffix: endIcon != null
                  ? InkWell(
                      onTap: endIconOnTap,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Icon(endIcon),
                      ),
                    )
                  : null,
              prefix: _prefix,
              controller: controller,
              placeholder: hintText,
              textAlignVertical: isExtended
                  ? TextAlignVertical.top
                  : TextAlignVertical.center,
              textAlign: TextAlign.left,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
