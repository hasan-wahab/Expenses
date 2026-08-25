import 'package:expense_app/core/constant/const_text/auth_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_states.dart';
import 'package:expense_app/features/auth/presentation/widgets/devider_row.dart';
import 'package:expense_app/features/widgets/app_checkbox.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/get_it.dart';
import '../../../../core/extensions/text_controller_extension.dart';
import '../../../../core/utils/validation_utils.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController usernameCtr = TextEditingController();
  final TextEditingController emailCtr = TextEditingController();
  final TextEditingController passwordCtr = TextEditingController();
  final TextEditingController cPasswordCtr = TextEditingController();
  bool isAgree = false;

  @override
  void dispose() {
    [usernameCtr, emailCtr, passwordCtr, cPasswordCtr].disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthStates>(
        listener: (context, state) {
          if (state is SingUpStatusStates) {
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.error) {
              context.hideCustomLoading();
              context.showSnackBar(state.message);
            }
            if (state.status == Status.success) {
              context.hideCustomLoading();
              [usernameCtr, emailCtr, passwordCtr, cPasswordCtr].resetAll();
              isAgree = false;
              context.showSnackBar('Account created. Please login.');
              context.go(RoutesName.login, extra: true);
            }
            if (state.status == Status.initial) {
              isAgree = state.isAgree;
            }
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: 490.8.h,
            width: 350.w,
            child: Column(
              mainAxisAlignment: .spaceBetween,
              children: [
                AppTField(
                  controller: usernameCtr,
                  hintText: AuthText.fullName.toTitleCase(),
                  labelText: AuthText.fullName.toTitleCase(),
                  startIcon: Icons.person,
                ),
                AppTField(
                  controller: emailCtr,
                  hintText: AuthText.email.toTitleCase(),
                  labelText: AuthText.email.toTitleCase(),
                  startIcon: Icons.email,
                ),
                AppTField(
                  controller: passwordCtr,
                  hintText: AuthText.password.toTitleCase(),
                  labelText: AuthText.password.toTitleCase(),
                  startIcon: Icons.lock,
                ),
                AppTField(
                  controller: cPasswordCtr,
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
                      AppCheckbox(
                        value: isAgree,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(
                            OnAgreeEvent(isAgree: value),
                          );
                        },
                      ),
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
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                                style: context.smallText!.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              TextSpan(text: AuthText.and),
                              TextSpan(
                                text: AuthText.privacy.toTitleCase(),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
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
                  onTap: () {
                    context.read<AuthBloc>().add(
                      OnPressedCreateEvent(
                        username: usernameCtr.text.trim(),
                        email: emailCtr.text.trim(),
                        password: passwordCtr.text.trim(),
                        cPassword: cPasswordCtr.text.trim(),
                        isAgree: isAgree,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
