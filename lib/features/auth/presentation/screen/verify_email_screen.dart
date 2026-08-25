import 'package:expense_app/core/constant/const_text/auth_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/di/get_it.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_states.dart';
import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final value = await sl<AuthUseCases>().getCurrentAuthEmailCall();
    if (!mounted) return;
    setState(() => email = value ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthStates>(
        listener: (context, state) {
          if (state is EmailVerificationState) {
            if (state.status == Status.success) {
              if (state.isVerified) {
                context.go(RoutesName.syncDataScreen, extra: false);
              } else if (state.message.isNotEmpty) {
                context.showSnackBar(state.message);
              }
            }
            if (state.status == Status.error) {
              context.showSnackBar(state.message, isError: true);
            }
          }
        },

        /// Builder gives a context under BlocProvider (screen context is above it)
        child: BlocBuilder<AuthBloc, AuthStates>(
          builder: (context, state) {
            final loading =
                state is EmailVerificationState &&
                state.status == Status.loading;
            return Scaffold(
              backgroundColor: AppColors.bgColor,
              appBar: CustomAppBar(
                title: AuthText.verifyEmailTitle,
                isLeading: true,
                leadingOnTap: () => context.go(RoutesName.login),
              ),
              body: SafeArea(
                top: false,
                child: loading
                    ? AppShimmer.form()
                    : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      Icon(
                        Icons.mark_email_unread_outlined,
                        size: 64.r,
                        color: context.iconAccent,
                      ),
                      SizedBox(height: 24.h),
                      SecondaryText(text: AuthText.verifyEmailTitle),
                      SizedBox(height: 12.h),
                      SmallText(
                        align: TextAlign.center,
                        maxLine: 6,
                        text: AuthText.verifyEmailMessage,
                      ),
                      if (email.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        SmallText(
                          align: TextAlign.center,
                          text: email,
                          style: context.smallText!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const Spacer(),
                      PrimaryButton(
                        text: AuthText.continueText,
                        onTap: () {
                          context.read<AuthBloc>().add(
                            CheckEmailVerifiedEvent(),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      PrimaryButton(
                        isOutline: true,
                        text: AuthText.resendEmail,
                        onTap: () {
                          context.read<AuthBloc>().add(
                            SendEmailVerificationEvent(),
                          );
                        },
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
