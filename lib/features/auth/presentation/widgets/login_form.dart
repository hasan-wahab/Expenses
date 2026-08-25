import 'package:expense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/widgets/devider_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/const_text/auth_text.dart';
import '../../../../core/constant/themes/themes/colors.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../widgets/app_t_field.dart';
import '../../../widgets/extra_small_text.dart';
import '../../../widgets/priamary_butn.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  bool isObscure;
  LoginForm({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    this.isObscure = true,
  });

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
            controller: emailCtrl,
            labelText: 'Email',
            hintText: 'Enter your email...',
            startIcon: Icons.email,
          ),
          SizedBox(height: 16.h),
          AppTField(
            isObscure: isObscure,

            /// Add event for the password obscure true / false
            endIconOnTap: () => context.read<AuthBloc>().add(
              ObsecurePasswordEvent(isObscure: isObscure),
            ),
            controller: passwordCtrl,
            labelText: 'Password',
            hintText: 'Enter your password...',
            startIcon: Icons.lock,
            endIcon: isObscure ? Icons.visibility_off : Icons.visibility,
          ),
          SizedBox(height: 60.h),
          PrimaryButton(
            text: AuthText.login.toTitleCase(),

            /// Press login button
            /// event add on auth bloc for user logging
            onTap: () => context.read<AuthBloc>().add(
              OnPressedLoginEvent(
                email: emailCtrl.text.trim(),
                password: passwordCtrl.text.trim(),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          DeviderRow(),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: .center,
            children: [
              InkWell(
                /// Here use can add the event for login with finger print
                onTap: () =>
                    context.read<AuthBloc>().add(LoginWithFingerPrintEvent()),
                child: Column(
                  mainAxisSize: .min,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
