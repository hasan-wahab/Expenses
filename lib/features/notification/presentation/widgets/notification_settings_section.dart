import 'package:expense_app/core/constant/const_text/notification_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/themes/themes/colors.dart';
import '../../../widgets/secondery_text.dart';

class NotificationSettingsSection extends StatelessWidget {
  const NotificationSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        spacing: 10.h,
        children: [
          NotificationListTile(
            title: NotificationText.pushNotif,
            leadingIcon: Icons.wallet,
            isOn: true,
            onChange: (value) {},
            isShowLastIndexDivider: false,
          ),
        ],
      ),
    );
  }
}

class NotificationListTile extends StatelessWidget {
  final double? iconSize;
  final String title;
  final IconData leadingIcon;
  bool isOn;
  final Function(bool) onChange;
  bool isShowLastIndexDivider;

  NotificationListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.isOn = false,
    this.isShowLastIndexDivider = true,
    this.iconSize,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: .symmetric(horizontal: 16.w),
          leading: Icon(leadingIcon),
          trailing: Switch(
            thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white; // ON state
              }
              return Colors.grey; // OFF state
            }),

            // 🟢 Background (track) color
            trackColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary; // ON state
              }
              return Colors.white; // OFF state
            }),

            value: isOn,
            onChanged: onChange,
          ),
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
