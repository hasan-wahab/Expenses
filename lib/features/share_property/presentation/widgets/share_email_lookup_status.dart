import 'package:expense_app/core/constant/const_text/share_property_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/share_property/domain/share_member_ui.dart';
import 'package:expense_app/features/share_property/presentation/bloc/share_property_states.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareEmailLookupStatus extends StatelessWidget {
  final SharePropertyState state;

  const ShareEmailLookupStatus({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final lookup = state.emailLookup;
    if (lookup == ShareEmailLookup.searching) {
      return Row(
        children: [
          SizedBox(
            width: 12.r,
            height: 12.r,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8.w),
          ExtraSmallText(
            text: SharePropertyText.checkingEmail,
            style: context.extraSmallText!.copyWith(
              color: AppColors.secondaryTColor,
            ),
          ),
        ],
      );
    }
    if (lookup == ShareEmailLookup.found) {
      final name = state.foundUser?.name?.trim();
      final label = (name != null && name.isNotEmpty)
          ? '${SharePropertyText.emailFound} ($name)'
          : SharePropertyText.emailFound;
      return ExtraSmallText(
        text: label,
        maxLine: 2,
        style: context.extraSmallText!.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    if (lookup == ShareEmailLookup.notFound) {
      return ExtraSmallText(
        text: SharePropertyText.emailNotValid,
        maxLine: 2,
        style: context.extraSmallText!.copyWith(
          color: AppColors.redColor,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    if (lookup == ShareEmailLookup.offline) {
      return ExtraSmallText(
        text: SharePropertyText.needInternet,
        maxLine: 2,
        style: context.extraSmallText!.copyWith(
          color: AppColors.redColor,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    if (lookup == ShareEmailLookup.ownEmail) {
      return ExtraSmallText(
        text: SharePropertyText.cannotShareSelf,
        maxLine: 2,
        style: context.extraSmallText!.copyWith(
          color: AppColors.redColor,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return ExtraSmallText(
      text: SharePropertyText.emailHelper,
      maxLine: 2,
      style: context.extraSmallText!.copyWith(
        color: AppColors.secondaryTColor,
      ),
    );
  }
}
