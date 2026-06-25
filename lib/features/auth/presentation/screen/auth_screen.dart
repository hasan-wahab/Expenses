import 'package:expense_app/core/constant/const_text/auth_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthStates>(
        listener: (context, state) {
          if (state is LoginStatusState) {
            if (state.status == Status.loading) {
              context.showSnackBar('Loading');
            }
            if (state.status == Status.success) {
              context.showSnackBar(state.message);
            }

            if (state.status == Status.error) {
              print(state.message);
              context.showSnackBar(state.message.toString());
            }
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
                    LoginForm(),

                    /// Login footer
                    Row(
                      spacing: 5.w,
                      mainAxisAlignment: .center,
                      children: [
                        SmallText(text: AuthText.dontHaveAccount),
                        InkWell(
                          onTap: () {},
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
