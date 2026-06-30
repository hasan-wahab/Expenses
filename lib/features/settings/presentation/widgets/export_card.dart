import 'package:expense_app/core/constant/const_text/settings_screen_text.dart';
import 'package:expense_app/features/property/presentation/widgets/recent_transactions.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'account_settings.dart';

class ExportCard extends StatelessWidget {
  const ExportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: .start,
      children: [
        ExtraSmallText(text: 'Others'),
        Card(
          child: SettingsListTile(
            isShowLastIndexDivider: false,
            title: SettingsScreenText.exportPdf,
            leadingIcon: Icons.picture_as_pdf,
            trailingIcon: Icons.arrow_forward_ios,
          ),
        ),
      ],
    );
  }
}
