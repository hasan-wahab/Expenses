import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// YouTube-style grey + white sweep — same colors as ali_therapy_admin.
class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  static Animation<double>? animationOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AppShimmerScope>()
        ?.animation;
  }

  @override
  State<AppShimmer> createState() => _AppShimmerState();

  static Widget bone({
    double? width,
    double? height,
    double radius = 12,
  }) {
    return AppShimmerBone(
      width: width,
      height: height,
      borderRadius: radius,
    );
  }

  static Widget circle({double size = 48}) {
    return AppShimmerBone(
      width: size.r,
      height: size.r,
      shape: BoxShape.circle,
    );
  }

  static Widget button() {
    return AppShimmer(
      child: bone(width: 160.w, height: 18.h, radius: 8),
    );
  }

  static Widget line({double width = 120, double height = 12}) {
    return AppShimmer(
      child: bone(width: width.w, height: height.h, radius: 6),
    );
  }

  static Widget cards({int count = 4}) {
    return _page(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        itemCount: count,
        itemBuilder: (_, index) => Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: bone(width: double.infinity, height: 168.h, radius: 16),
        ),
      ),
    );
  }

  static Widget form() {
    return _page(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        children: [
          Center(child: circle(size: 88)),
          SizedBox(height: 24.h),
          bone(width: 180.w, height: 18.h),
          SizedBox(height: 16.h),
          bone(width: double.infinity, height: 48.h),
          SizedBox(height: 16.h),
          bone(width: double.infinity, height: 48.h),
          SizedBox(height: 16.h),
          bone(width: double.infinity, height: 48.h),
          SizedBox(height: 16.h),
          bone(width: double.infinity, height: 48.h),
          SizedBox(height: 28.h),
          bone(width: double.infinity, height: 48.h, radius: 12),
        ],
      ),
    );
  }

  static Widget summary() {
    return _page(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          bone(width: double.infinity, height: 96.h, radius: 16),
          SizedBox(height: 24.h),
          bone(width: double.infinity, height: 180.h, radius: 16),
          SizedBox(height: 24.h),
          bone(width: 140.w, height: 16.h),
          SizedBox(height: 12.h),
          bone(width: double.infinity, height: 64.h, radius: 12),
          SizedBox(height: 12.h),
          bone(width: double.infinity, height: 64.h, radius: 12),
          SizedBox(height: 12.h),
          bone(width: double.infinity, height: 64.h, radius: 12),
        ],
      ),
    );
  }

  static Widget settings() {
    return _page(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        children: [
          Row(
            children: [
              circle(size: 64),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bone(width: 140.w, height: 16.h),
                  SizedBox(height: 8.h),
                  bone(width: 180.w, height: 12.h),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          bone(width: double.infinity, height: 56.h),
          SizedBox(height: 12.h),
          bone(width: double.infinity, height: 56.h),
          SizedBox(height: 12.h),
          bone(width: double.infinity, height: 56.h),
          SizedBox(height: 24.h),
          bone(width: double.infinity, height: 80.h, radius: 16),
        ],
      ),
    );
  }

  static Widget members() {
    return AppShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Column(
          children: [
            Row(
              children: [
                circle(size: 36),
                SizedBox(width: 12.w),
                bone(width: 160.w, height: 14.h),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                circle(size: 36),
                SizedBox(width: 12.w),
                bone(width: 140.w, height: 14.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget boot() {
    return const ColoredBox(
      color: Color(0xFFFFFFFF),
      child: AppShimmer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            children: [
              AppShimmerBone(width: 88, height: 88, shape: BoxShape.circle),
              SizedBox(height: 24),
              AppShimmerBone(width: double.infinity, height: 48, borderRadius: 12),
              SizedBox(height: 16),
              AppShimmerBone(width: double.infinity, height: 48, borderRadius: 12),
              SizedBox(height: 16),
              AppShimmerBone(width: double.infinity, height: 48, borderRadius: 12),
              SizedBox(height: 28),
              AppShimmerBone(width: double.infinity, height: 48, borderRadius: 12),
            ],
          ),
        ),
      ),
    );
  }

  static Widget page() => form();

  static Widget sync() {
    return _page(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            bone(width: 120.w, height: 40.h),
            SizedBox(height: 24.h),
            bone(width: double.infinity, height: 8.h, radius: 8),
            SizedBox(height: 20.h),
            bone(width: 220.w, height: 14.h),
          ],
        ),
      ),
    );
  }

  /// White page so mint app background cannot mix into a pink/red cast.
  static Widget _page({required Widget child}) {
    return ColoredBox(
      color: const Color(0xFFFFFFFF),
      child: AppShimmer(child: child),
    );
  }
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AppShimmerScope(animation: _controller, child: widget.child);
  }
}

class _AppShimmerScope extends InheritedWidget {
  const _AppShimmerScope({required this.animation, required super.child});

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_AppShimmerScope oldWidget) {
    return oldWidget.animation != animation;
  }
}

/// Soft grey bone with moving white highlight (same as ali_therapy_admin).
class AppShimmerBone extends StatelessWidget {
  const AppShimmerBone({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxShape shape;

  static const Color _base = Color(0xFFE6E6E6);
  static const Color _mid = Color(0xFFF0F0F0);
  static const Color _shine = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final animation = AppShimmer.animationOf(context);
    final radius = shape == BoxShape.circle
        ? null
        : BorderRadius.circular(borderRadius ?? 6.r);

    if (animation == null) {
      return Container(
        width: width,
        height: height ?? 12.h,
        decoration: BoxDecoration(
          color: _base,
          shape: shape,
          borderRadius: radius,
        ),
      );
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value;
        final slide = (t * 2) - 1;

        return Container(
          width: width,
          height: height ?? 12.h,
          decoration: BoxDecoration(
            shape: shape,
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment(slide - 1, 0),
              end: Alignment(slide + 1, 0),
              colors: const [_base, _base, _mid, _shine, _mid, _base, _base],
              stops: const [0.0, 0.30, 0.42, 0.50, 0.58, 0.70, 1.0],
            ),
          ),
        );
      },
    );
  }
}
