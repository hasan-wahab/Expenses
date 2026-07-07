import 'package:expense_app/core/constant/const_text/auth_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/core/utils/validation_utils.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_states.dart';
import 'package:expense_app/features/auth/presentation/widgets/login_form.dart';
import 'package:expense_app/features/widgets/app_b_text.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/extra_large_text.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:app_settings/app_settings.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/get_it.dart';
import '../../../widgets/small_text.dart';
import '../widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthStates>(
        listener: (context, state) {
          if (state is LoginStatusState) {
            /// Loading...
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }

            /// If user User Successfully login then go to Nave Bar Page
            if (state.status == Status.success) {
              context.pop();
              context.go(RoutesName.naveBar);
            }

            /// If message is No_fingerprint then show the dialog for Device user
            if (state.status == Status.error) {
              context.pop();
              if (state.message == 'No_Fingerprint') {
                context.appSettings(
                  type: AppSettingsType.security,
                  title: 'Biometric no set',
                  message:
                      'No fingerprint is set up on this device. Please add a fingerprint in your device settings.',
                );
              } else {
                /// Other message will show on display
                context.showSnackBar(state.message.toString());
              }
            }
          }
          if (state is ObscurePasswordState) {
            /// for the password visibility
            isObscure = state.isObscure;
          }
        },
        child: BlocBuilder<AuthBloc, AuthStates>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.bgColor,
              body: SafeArea(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    /// Login Header
                    LoginHeader(),

                    /// Login Form
                    LoginForm(
                      isObscure: isObscure,
                      emailCtrl: emailCtrl,
                      passwordCtrl: passwordCtrl,
                    ),

                    /// Login footer
                    Row(
                      spacing: 5.w,
                      mainAxisAlignment: .center,
                      children: [
                        SmallText(text: AuthText.dontHaveAccount),
                        InkWell(
                          onTap: () => context.push(RoutesName.singUp),
                          child: SmallText(
                            text: AuthText.signUp,
                            style: context.smallText!.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
