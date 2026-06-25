import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/auth/presentation/widgets/devider_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/const_text/auth_text.dart';
import '../../../../core/constant/themes/themes/colors.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../widgets/app_t_field.dart';
import '../../../widgets/extra_small_text.dart';
import '../../../widgets/priamary_butn.dart';
import '../../../widgets/small_text.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 444.h,
      width: 350.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: .start,
        children: [
          AppTField(
            labelText: 'Email',
            hintText: 'Email',
            startIcon: Icons.email,
          ),
          SizedBox(height: 16.h),
          AppTField(
            labelText: 'Password',
            hintText: 'Password',
            startIcon: Icons.lock,
            endIcon: Icons.remove_red_eye,
          ),
          SizedBox(height: 60.h),
          PrimaryButton(
            text: AuthText.login.toTitleCase(),
            onTap: () => context.push(RoutesName.singUp),
          ),
          SizedBox(height: 20.h),
          DeviderRow(),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: .center,
            children: [
              Column(
                spacing: 12.h,
                children: [
                  Container(
                    height: 64.h,
                    width: 64.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Icon(Icons.fingerprint, size: 24.r),
                  ),
                  ExtraSmallText(text: AuthText.fingerPrint),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
