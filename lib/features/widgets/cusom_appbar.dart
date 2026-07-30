import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/constant/themes/themes/colors.dart';
import 'app_b_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  bool isLeading = true;
  final IconData? actionIcon1;
  final IconData? actionIcon2;
  final VoidCallback? leadingOnTap;
  final VoidCallback? actionIcon1Ontap;
  final VoidCallback? actionIcon2Ontap;
  final String? profileImagePath;

  CustomAppBar({
    super.key,
    this.isLeading = false,
    required this.title,
    this.leadingIcon = Icons.arrow_back_ios,
    this.actionIcon1,
    this.actionIcon2,
    this.leadingOnTap,
    this.actionIcon1Ontap,
    this.actionIcon2Ontap,
    this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            boxShadow: [
              BoxShadow(color: AppColors.primary, offset: Offset(0, 1)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 3.w,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    isLeading
                        ? InkWell(
                            onTap: leadingOnTap ?? () => context.pop(),
                            child: Icon(leadingIcon),
                          )
                        : const SizedBox.shrink(),
                    AppBarText(text: title),
                  ],
                ),
              ),
              profileImagePath != null
                  ? Container(
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                        color: AppColors.bannerYellowColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person),
                    )
                  : Expanded(
                      flex: 1,
                      child: Row(
                        spacing: actionIcon2 != null ? 10.w : 0,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (actionIcon1 != null)
                            InkWell(
                              onTap: actionIcon1Ontap,
                              borderRadius: BorderRadius.circular(20.r),
                              child: Padding(
                                padding: EdgeInsets.all(4.r),
                                child: Icon(
                                  actionIcon1,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          if (actionIcon2 != null)
                            InkWell(
                              onTap: actionIcon2Ontap,
                              borderRadius: BorderRadius.circular(20.r),
                              child: Padding(
                                padding: EdgeInsets.all(4.r),
                                child: Icon(
                                  actionIcon2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(56.h + ScreenUtil().statusBarHeight);
}
