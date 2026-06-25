import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/themes/themes/colors.dart';
import 'app_b_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final IconData? actionIcon1;
  final IconData? actionIcon2;
  final VoidCallback? leadingOntap;
  final VoidCallback? actionIcon1Ontap;
  final VoidCallback? actionIcon2Ontap;
  const CustomAppBar({
    super.key,
    required this.title,
    this.leadingIcon = Icons.arrow_back_ios,
    this.actionIcon1,
    this.actionIcon2,
    this.leadingOntap,
    this.actionIcon1Ontap,
    this.actionIcon2Ontap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
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
                crossAxisAlignment: .center,
                spacing: 3.w,
                mainAxisAlignment: .start,
                children: [
                  Icon(leadingIcon),
                  AppBarText(text: title),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: .center,

                mainAxisAlignment: .end,
                children: [
                  actionIcon1 != null
                      ? InkWell(
                          onTap: actionIcon1Ontap,
                          child: InkWell(
                            onTap: actionIcon2Ontap,
                            child: Icon(actionIcon1),
                          ),
                        )
                      : Container(),
                  actionIcon2 != null ? Icon(actionIcon2) : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.h);
}
