import 'package:expense_app/core/di/get_it.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/onboarding/data/onboarding_local.dart';
import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveSession());
  }

  Future<void> _resolveSession() async {
    try {
      final onboardingDone = await sl<OnboardingLocal>().isCompleted();
      if (!mounted) return;

      if (!onboardingDone) {
        context.go(RoutesName.onboarding);
        return;
      }

      final useCases = sl<AuthUseCases>();

      /// Only after local logout / signup: ask login.
      /// After a successful login, this flag is cleared so app reopen skips login.
      final requiresLogin = await useCases.requiresLoginCall();
      if (!mounted) return;
      if (requiresLogin) {
        context.go(RoutesName.login, extra: true);
        return;
      }

      /// Already logged in once (Firebase session kept) → enter app, no login again.
      final hasSession = await useCases.hasValidSessionCall();
      if (!mounted) return;

      if (hasSession) {
        context.go(RoutesName.syncDataScreen, extra: false);
        return;
      }

      final authEmail = await useCases.getCurrentAuthEmailCall();
      if (!mounted) return;

      if (authEmail != null) {
        /// EMAIL VERIFICATION DISABLED — always continue when Firebase user exists.
        // final verified = await useCases.isEmailVerifiedCall();
        // if (!mounted) return;
        // if (verified) {
        //   context.go(RoutesName.syncDataScreen, extra: false);
        // } else {
        //   context.go(RoutesName.verifyEmail);
        // }
        // return;
        context.go(RoutesName.syncDataScreen, extra: false);
        return;
      }

      context.go(RoutesName.login, extra: true);
    } catch (_) {
      if (!mounted) return;
      context.go(RoutesName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: AppShimmer.page()),
    );
  }
}
