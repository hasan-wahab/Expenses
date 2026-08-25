import 'dart:io';

import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharePropertyHeader extends StatelessWidget {
  final DashboardCardEntity entity;
  const SharePropertyHeader({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                height: 56.h,
                width: 56.w,
                child: _image(entity.imageUrl),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SecondaryText(text: entity.propertyName),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.r,
                        color: context.iconColor,
                      ),
                      SizedBox(width: 2.w),
                      Flexible(
                        child: SmallText(text: entity.propertyLocation),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(String imageUrl) {
    final hasLocal = imageUrl.isNotEmpty && File(imageUrl).existsSync();
    if (hasLocal) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Image.asset('assets/images/app_logo.png', fit: BoxFit.cover);
  }
}
