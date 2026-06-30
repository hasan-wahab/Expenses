import 'package:expense_app/core/constant/const_text/export_pdf_text.dart';
import 'package:expense_app/features/export_pdf/presentation/screen/export_to_pdf_screen.dart';
import 'package:expense_app/features/settings/presentation/widgets/account_settings.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectionPeriodCard extends StatelessWidget {
  const SelectionPeriodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: .start,
      children: [
        SecondaryText(text: ExportPdfText.selectPeriod),

        Card(
          child: Column(
            children: [
              SettingsListTile(
                iconSize: 18.r,
                title: ExportPdfText.thisMonth,
                leadingIcon: Icons.calendar_month,
                trailingIcon: Icons.keyboard_arrow_down_rounded,
              ),
              SettingsListTile(
                iconSize: 18.r,
                title: ExportPdfText.lastQuarter,
                leadingIcon: Icons.calendar_month,
                trailingIcon: Icons.keyboard_arrow_down_rounded,
              ),
              SettingsListTile(
                isShowLastIndexDivider: false,
                iconSize: 18.r,
                title: ExportPdfText.customRange,
                leadingIcon: Icons.calendar_month,
                trailingIcon: Icons.keyboard_arrow_down_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
