import 'package:expense_app/core/constant/const_text/onboarding_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/di/get_it.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/onboarding/data/onboarding_local.dart';
import 'package:expense_app/features/onboarding/presentation/widgets/onboarding_dots.dart';
import 'package:expense_app/features/onboarding/presentation/widgets/onboarding_illustrations.dart';
import 'package:expense_app/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _index = 0;

  static final List<_OnboardingItem> _pages = [
    _OnboardingItem(
      title: OnboardingText.title1,
      body: OnboardingText.body1,
      illustration: OnboardingIllustrations.properties(),
    ),
    _OnboardingItem(
      title: OnboardingText.title2,
      body: OnboardingText.body2,
      illustration: OnboardingIllustrations.expenses(),
    ),
    _OnboardingItem(
      title: OnboardingText.title3,
      body: OnboardingText.body3,
      illustration: OnboardingIllustrations.reports(),
    ),
    _OnboardingItem(
      title: OnboardingText.title4,
      body: OnboardingText.body4,
      illustration: OnboardingIllustrations.security(),
    ),
  ];

  bool get _isLast => _index == _pages.length - 1;

  Future<void> _finish() async {
    await sl<OnboardingLocal>().markCompleted();
    if (!mounted) return;
    context.go(RoutesName.login);
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: SmallText(
                  text: OnboardingText.skip,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryTColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    title: page.title,
                    body: page.body,
                    illustration: page.illustration,
                  );
                },
              ),
            ),
            OnboardingDots(count: _pages.length, index: _index),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PrimaryButton(
                text: _isLast ? OnboardingText.getStarted : OnboardingText.next,
                onTap: _next,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.title,
    required this.body,
    required this.illustration,
  });

  final String title;
  final String body;
  final Widget illustration;
}
