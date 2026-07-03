import 'package:expense_app/core/constant/const_text/notification_text.dart';
import 'package:expense_app/features/notification/presentation/widgets/notification_settings_section.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/themes/themes/colors.dart';
import '../../../widgets/secondery_text.dart';
import '../widgets/notifi_header.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: NotificationText.appBarText,
        actionIcon1: Icons.notifications,
      ),
      body: ListView(
        padding: .symmetric(horizontal: 20.w),
        children: [

          SizedBox(height: 24.h,),
          /// Header
          NotifHeader(),
          SizedBox(height: 24.h,),
          /// Notification Settings Sections
          NotificationSettingsSection(),
        ],
      ),
    );

  }
}
