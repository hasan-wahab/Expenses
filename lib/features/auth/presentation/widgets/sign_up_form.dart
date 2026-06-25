import 'package:expense_app/core/constant/const_text/auth_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/auth/presentation/widgets/devider_row.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 490.8.h,
      width: 350.w,
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          AppTField(
            hintText: AuthText.fullName.toTitleCase(),
            labelText: AuthText.fullName.toTitleCase(),
            startIcon: Icons.person,
          ),
          AppTField(
            hintText: AuthText.email.toTitleCase(),
            labelText: AuthText.email.toTitleCase(),
            startIcon: Icons.email,
          ),
          AppTField(
            hintText: AuthText.password.toTitleCase(),
            labelText: AuthText.password.toTitleCase(),
            startIcon: Icons.lock,
          ),
          AppTField(
            hintText: AuthText.confirmPassword.toTitleCase(),
            labelText: AuthText.confirmPassword.toTitleCase(),
            startIcon: Icons.lock,
          ),
          SizedBox(
            width: 350.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: .max,
              children: [
                Checkbox(value: false, onChanged: (vaa) {}),
                SizedBox(width: 5.w),
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: AuthText.iAgree.toCapitalize(),
                      style: context.extraSmallText,
                      children: [
                        TextSpan(
                          text: AuthText.termsAndCondition.toTitleCase(),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          style: context.smallText!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        TextSpan(text: AuthText.and),
                        TextSpan(
                          text: AuthText.privacy.toTitleCase(),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          style: context.smallText!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          PrimaryButton(
            text: AuthText.signUp,
            onTap: () => context.push(RoutesName.dashboard),
          ),
        ],
      ),
    );
  }
}
