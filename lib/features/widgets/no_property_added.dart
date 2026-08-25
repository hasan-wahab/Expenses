import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/constant/wrapers.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Shared empty state when user has no property cards yet.
class NoPropertyAdded extends StatelessWidget {
  const NoPropertyAdded({super.key, required this.onPropertyAdded});

  final VoidCallback onPropertyAdded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.home_work_outlined,
              size: 56.r,
              color: context.iconAccent,
            ),
            SizedBox(height: 20.h),
            SmallText(
              align: TextAlign.center,
              maxLine: 3,
              text: DashboardText.noPropertyAdded,
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              width: double.infinity,
              text: DashboardText.addNew,
              onTap: () async {
                final result = await context.push(
                  RoutesName.addPropertyScreen,
                  extra: AppPropertyArgs(mode: AddPropertyMode.add),
                );
                if (result == true) {
                  onPropertyAdded();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
