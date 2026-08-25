import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Lightweight illustrations using only Flutter widgets/icons.
class OnboardingIllustrations {
  OnboardingIllustrations._();

  static Widget properties() {
    return Builder(
      builder: (context) {
        return _IllustrationFrame(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.home_outlined,
                size: 120.r,
                color: context.iconAccent.withValues(alpha: 0.12),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _InfoChip(
                    icon: Icons.apartment_rounded,
                    label: 'Apartment',
                    trailing: 'PKR',
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MiniCard(icon: Icons.bolt_rounded, label: 'Electric'),
                      SizedBox(width: 10.w),
                      _MiniCard(icon: Icons.verified_rounded, label: 'Synced'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget expenses() {
    return _IllustrationFrame(
      child: Container(
        width: 140.w,
        height: 200.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(Icons.home_work_rounded, color: AppColors.primary, size: 24.r),
            SizedBox(height: 10.h),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _CategoryRow(icon: Icons.bolt_rounded, label: 'Electric'),
                  _CategoryRow(
                    icon: Icons.local_fire_department_rounded,
                    label: 'Gas',
                  ),
                  _CategoryRow(icon: Icons.water_drop_rounded, label: 'Water'),
                  _CategoryRow(
                    icon: Icons.receipt_long_rounded,
                    label: 'Receipt',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget reports() {
    return _IllustrationFrame(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150.w,
            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 14.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _Bar(height: 36.h),
                    SizedBox(width: 8.w),
                    _Bar(height: 58.h),
                    SizedBox(width: 8.w),
                    _Bar(height: 44.h),
                    SizedBox(width: 8.w),
                    _Bar(height: 70.h),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'Insights',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryTColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          Container(
            width: 72.w,
            height: 92.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary, size: 28.r),
                SizedBox(height: 8.h),
                Icon(Icons.check_circle_rounded, color: AppColors.primaryDark, size: 18.r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget security() {
    return _IllustrationFrame(
      child: Container(
        width: 180.r,
        height: 180.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(0.12),
        ),
        child: Center(
          child: Container(
            width: 118.r,
            height: 118.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Icon(
              Icons.fingerprint_rounded,
              size: 56.r,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _IllustrationFrame extends StatelessWidget {
  const _IllustrationFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280.h,
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Center(child: child),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  final IconData icon;
  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.iconAccent, size: 22.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
          ),
          Text(
            trailing,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: context.iconAccent, size: 22.r),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryTColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.r, color: context.iconColor),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.w,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}
