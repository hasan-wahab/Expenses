import 'package:expense_app/core/constant/const_text/settings_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: .start,
      children: [
        /// Account Settings Card
        ExtraSmallText(text: SettingsScreenText.accountSettings),
        Card(
          child: Column(
            children: [
              SettingsListTile(
                leadingIcon: Icons.person,
                title: SettingsScreenText.personalInfo,
                trailingIcon: Icons.arrow_forward_ios,
              ),
              SettingsListTile(
                leadingIcon: Icons.notifications_none,
                title: SettingsScreenText.notif,
                trailingIcon: Icons.arrow_forward_ios,
              ),
              SettingsListTile(
                leadingIcon: Icons.money,
                title: SettingsScreenText.currency,
                trailingIcon: Icons.arrow_forward_ios,

                /// For Last Index Divider is In visible
                isShowLastIndexDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final double? iconSize;
  final String title;
  final IconData leadingIcon;
  final IconData trailingIcon;
  bool isShowLastIndexDivider;

  SettingsListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.trailingIcon,
    this.isShowLastIndexDivider = true,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: .symmetric(horizontal: 16.w),
          leading: Icon(leadingIcon),
          trailing: Icon(trailingIcon, size: iconSize ?? 12.r),
          title: SecondaryText(text: title),
        ),
        isShowLastIndexDivider
            ? Divider(
                color: AppColors.primary.withOpacity(0.2),
                thickness: 1.h,
                height: 1.h,
              )
            : Container(),
      ],
    );
  }
}
