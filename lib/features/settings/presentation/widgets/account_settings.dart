import 'package:expense_app/core/constant/const_text/settings_screen_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_events.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_states.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/get_it.dart';

class AccountSettings extends StatelessWidget {
  bool value;
  AccountSettings({super.key, required this.value});

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
              ),
              FingerPrintListTile(
                title: SettingsScreenText.finger,
                leadingIcon: Icons.fingerprint,
                isOn: value,
                onChange: (value) {
                  context.read<SettingsBloc>().add(
                    OnSettingsEvent(isFingerPrintEnable: value),
                  );
                },
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

class FingerPrintListTile extends StatelessWidget {
  final double? iconSize;
  final String title;
  final IconData leadingIcon;
  bool isOn;
  final Function(bool) onChange;
  bool isShowLastIndexDivider;

  FingerPrintListTile({
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
            onChanged: (value) => onChange(value),
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
