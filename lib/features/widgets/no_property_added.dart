import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/constant/const_text/dashboard_text.dart';
import '../../core/router/routes_name.dart';
import 'add_new_floating_btn.dart';

class NoPropertyAdded extends StatelessWidget {
  const NoPropertyAdded({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: 30.w),
      child: Center(
        child: Column(
          spacing: 20.h,
          mainAxisSize: .min,
          children: [
            SmallText(
              align: .center,
              maxLine: 3,
              text:
                  "No properties added yet.\n Tap Add New Property to get started.",
            ),
          ],
        ),
      ),
    );
  }
}
