import 'package:expense_app/core/constant/const_text/property_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/date_extension.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .all(24.r),
      decoration: BoxDecoration(
        border: .all(color: AppColors.primary),
        borderRadius: .circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              SecondaryText(text: PropertyScreenText.recentTransection),
              SmallText(
                text: PropertyScreenText.seeAll,
                style: context.smallText!.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          ListTileWidget(),
          ListTileWidget(),
          ListTileWidget(),
          ListTileWidget(),
          ListTileWidget(),
          ListTileWidget(),
        ],
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      dense: true,
      visualDensity: .standard,
      contentPadding: .zero,
      leading: CircleAvatar(
        radius: 20.r,
      ),
      title: SmallText(text: 'Gas'),
      subtitle: ExtraSmallText(text: DateTime.now().toDisplayDate()),
      trailing: SmallText(text: PropertyScreenText.thisMonthExpenseValue),
    );
  }
}
