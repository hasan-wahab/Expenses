import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/devider_row.dart';
import '../widgets/sign_up_form.dart';
import '../widgets/sign_up_header.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(top: 32.h, left: 20.w, right: 20.w),
          children: [
            /// Sign Up Header
            SignUpHeader(),
            SizedBox(height: 20.h),

            /// Sign Up Form Section
            SignUpForm(),
            SizedBox(height: 16.h),
            DeviderRow(),
            SizedBox(height: 16.h),

            /// Login Button
            PrimaryButton(
              text: 'Login',
              onTap: () => context.go(RoutesName.login),
            ),

            // /// Google Button
            // PrimaryButton(
            //   text: 'Continue With Google',
            //   isOutline: true,
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
