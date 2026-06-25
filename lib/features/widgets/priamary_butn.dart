import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/app_b_text.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  bool isDisable;
  final String text;
  final TextStyle? style;
  bool isOutline;
  PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isDisable = false,
    this.isOutline = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisable ? null : onTap,
      child: Container(
        alignment: .center,
        decoration: BoxDecoration(
          color: !isOutline ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: isOutline ? Border.all(color: AppColors.primary) : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 3,
              blurStyle: BlurStyle.outer,
              offset: Offset(0, 2),
            ),
          ],
        ),
        height: 48.h,
        width: 350.w,
        child: isDisable
            ? CircularProgressIndicator(color: Colors.white)
            : AppBarText(
                text: text,
                style:
                    style ??
                    context.appBarTextStyle!.copyWith(
                      fontSize: !isOutline ? 20.sp : 12.sp,
                      color: !isOutline ? Colors.white : AppColors.primary,
                    ),
              ),
      ),
    );
  }
}
