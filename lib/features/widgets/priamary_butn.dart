import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/app_b_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? height;
  final double? width;
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
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisable ? null : onTap,
      child: Card(
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
          height: height ?? 48.h,
          width: width ?? 350.w,
          child: isDisable
              ? SizedBox(
                  height: 22.h,
                  width: 22.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: !isOutline ? Colors.white : AppColors.primary,
                  ),
                )
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
      ),
    );
  }
}
