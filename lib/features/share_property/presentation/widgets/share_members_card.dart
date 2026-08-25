import 'package:expense_app/core/constant/const_text/share_property_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/features/share_property/domain/share_member_ui.dart';
import 'package:expense_app/features/share_property/domain/share_permission_item.dart';
import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareMembersCard extends StatelessWidget {
  final List<ShareMemberUi> members;
  final ValueChanged<ShareMemberUi> onRemove;
  final bool isLoading;

  const ShareMembersCard({
    super.key,
    required this.members,
    required this.onRemove,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExtraSmallText(text: SharePropertyText.peopleWithAccess.toTitleCase()),
        SizedBox(height: 8.h),
        Card(
          margin: EdgeInsets.zero,
          color: AppColors.white,
          child: Column(
            children: [
              _ownerRow(context),
              Divider(
                height: 1.h,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
              if (isLoading)
                AppShimmer.members()
              else if (members.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: SmallText(
                    text: SharePropertyText.noFriendsYet,
                    maxLine: 2,
                    style: context.smallText!.copyWith(
                      color: AppColors.secondaryTColor,
                    ),
                  ),
                )
              else
                ...members.map(
                  (member) => _memberRow(context, member),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ownerRow(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
        child: Icon(
          Icons.person,
          color: context.colors.secondary,
          size: 20.r,
        ),
      ),
      title: SecondaryText(text: SharePropertyText.youOwner),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: ExtraSmallText(
          text: SharePropertyText.ownerBadge,
          style: context.extraSmallText!.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _memberRow(BuildContext context, ShareMemberUi member) {
    final labels = SharePermissionItem.all
        .where((p) => member.permissions.contains(p.id))
        .map((p) => p.title)
        .join(' · ');
    return Column(
      children: [
        Divider(
          height: 1.h,
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          leading: CircleAvatar(
            backgroundColor: AppColors.bannerYellowColor,
            child: ExtraSmallText(
              text: member.email.initialLetter,
              style: context.extraSmallText!.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),
          ),
          title: SecondaryText(
            text: (member.name != null && member.name!.trim().isNotEmpty)
                ? member.name!
                : member.email,
          ),
          subtitle: SmallText(
            text: labels,
            maxLine: 2,
            style: context.smallText!.copyWith(
              fontSize: 11.sp,
              color: AppColors.secondaryTColor,
            ),
          ),
          trailing: IconButton(
            tooltip: SharePropertyText.removeAccess,
            onPressed: () => onRemove(member),
            icon: Icon(Icons.close, color: context.iconError, size: 18.r),
          ),
        ),
      ],
    );
  }
}
