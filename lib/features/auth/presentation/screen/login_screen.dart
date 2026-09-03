import 'package:expense_app/core/constant/const_text/auth_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:expense_app/features/auth/presentation/bloc/auth_states.dart';
import 'package:expense_app/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:app_settings/app_settings.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/extensions/text_controller_extension.dart';
import '../../../widgets/small_text.dart';
import '../widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  /// When true (e.g. after Logout), do not auto-show biometric prompt.
  final bool skipFingerprintPrompt;

  const LoginScreen({super.key, this.skipFingerprintPrompt = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    _prefillSavedEmail();
  }

  Future<void> _prefillSavedEmail() async {
    final savedEmail = await sl<AuthUseCases>().getSavedEmailCall();
    if (!mounted || savedEmail == null) return;
    emailCtrl.text = savedEmail;
  }

  /// If fingerprint is enabled and a Firebase session still exists,
  /// show system biometric on login open.
  Future<void> _promptFingerprintIfEnabled(AuthBloc bloc) async {
    final enabled = await sl<AuthUseCases>().getFingerPrintCall() == true;
    if (!mounted || !enabled) return;

    /// After logout there is no session — skip auto prompt (email login first).
    final hasSession = await sl<AuthUseCases>().hasValidSessionCall();
    if (!mounted || !hasSession) return;

    bloc.add(LoginWithFingerPrintEvent());
  }

  @override
  void dispose() {
    [emailCtrl, passwordCtrl].disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<AuthBloc>();
        if (!widget.skipFingerprintPrompt) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _promptFingerprintIfEnabled(bloc);
          });
        }
        return bloc;
      },
      child: BlocListener<AuthBloc, AuthStates>(
        listener: (context, state) {
          if (state is LoginStatusState) {
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.success) {
              context.hideCustomLoading();
              passwordCtrl.reset();
              if (state.message == 'Login with fingerprint') {
                context.go(RoutesName.naveBar);
              } else {
                emailCtrl.reset();
                context.go(RoutesName.naveBar);
              }
            }

            if (state.status == Status.error) {
              context.hideCustomLoading();
              if (state.message == 'No_Fingerprint') {
                context.appSettings(
                  type: AppSettingsType.security,
                  title: 'Biometric no set',
                  message:
                      'No fingerprint is set up on this device. Please add a fingerprint in your device settings.',
                );
              } else if (state.message ==
                  'Please touch the fingerprint sensor.') {
                /// User canceled biometric — stay on login for email/password.
              } else {
                /// Other message will show on display
                context.showSnackBar(state.message.toString(), isError: true);
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
                          onTap: () => context.go(RoutesName.singUp),
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
