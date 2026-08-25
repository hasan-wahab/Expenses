import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/share_property/domain/share_permission_item.dart';
import 'package:expense_app/features/widgets/app_checkbox.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharePermissionTile extends StatelessWidget {
  final SharePermissionItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const SharePermissionTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.required ? null : onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.45)
                    : AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  Container(
                    height: 36.r,
                    width: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      item.icon,
                      size: 18.r,
                      color: context.colors.secondary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SecondaryText(text: item.title),
                        SizedBox(height: 2.h),
                        SmallText(
                          text: item.subtitle,
                          style: context.smallText!.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.secondaryTColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IgnorePointer(
                    child: AppCheckbox(
                      value: isSelected,
                      enabled: !item.required,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
