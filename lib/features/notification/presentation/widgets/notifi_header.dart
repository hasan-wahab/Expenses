import 'package:expense_app/core/constant/const_text/notification_text.dart';
import 'package:expense_app/core/constant/const_text/settings_screen_text.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';

class NotifHeader extends StatelessWidget {
  const NotifHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        LargeText(text: NotificationText.notificationSettings),
        SmallText(text: NotificationText.notifSubTitle, maxLine: 3),
      ],
    );
  }
}
