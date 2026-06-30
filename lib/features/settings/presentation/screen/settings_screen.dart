import 'package:expense_app/core/constant/const_text/settings_screen_text.dart';
import 'package:expense_app/features/settings/presentation/widgets/export_card.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/account_settings.dart';
import '../widgets/min_profile_info_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: SettingsScreenText.appBarText,
        profileImagePath: '',
      ),
      body: ListView(
        padding: .symmetric(horizontal: 20.w),
        children: [
          SizedBox(height: 24.h),

          /// Min Profile Info Card
          MinProfileInfoCard(),
          SizedBox(height: 24.h),
          AccountSettings(),
          SizedBox(height: 24.h),

          /// Export to pdf Print Card
          ExportCard(),
          SizedBox(height: 40.h),
          PrimaryButton(text: SettingsScreenText.logout, onTap: () {}),
        ],
      ),
    );
  }
}
