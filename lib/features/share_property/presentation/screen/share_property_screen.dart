import 'dart:async';

import 'package:expense_app/core/constant/const_text/share_property_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/di/get_it.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/share_property/domain/share_permission_item.dart';
import 'package:expense_app/features/share_property/presentation/bloc/share_property_bloc.dart';
import 'package:expense_app/features/share_property/presentation/bloc/share_property_events.dart';
import 'package:expense_app/features/share_property/presentation/bloc/share_property_states.dart';
import 'package:expense_app/features/share_property/presentation/widgets/share_email_lookup_status.dart';
import 'package:expense_app/features/share_property/presentation/widgets/share_members_card.dart';
import 'package:expense_app/features/share_property/presentation/widgets/share_permission_tile.dart';
import 'package:expense_app/features/share_property/presentation/widgets/share_property_header.dart';
import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharePropertyScreen extends StatefulWidget {
  final DashboardCardEntity cardEntity;

  const SharePropertyScreen({super.key, required this.cardEntity});

  @override
  State<SharePropertyScreen> createState() => _SharePropertyScreenState();
}

class _SharePropertyScreenState extends State<SharePropertyScreen> {
  final TextEditingController emailController = TextEditingController();
  Timer? _emailDebounce;
  SharePropertyBloc? _bloc;

  @override
  void dispose() {
    _emailDebounce?.cancel();
    emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    _emailDebounce?.cancel();
    _emailDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _bloc?.add(ShareEmailChangedEvent(email: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        _bloc = sl<SharePropertyBloc>()
          ..add(LoadShareMembersEvent(card: widget.cardEntity));
        return _bloc!;
      },
      child: BlocConsumer<SharePropertyBloc, SharePropertyState>(
        listenWhen: (previous, current) =>
            current.message != null &&
            current.message != previous.message &&
            (current.status == Status.error ||
                current.status == Status.success),
        listener: (context, state) {
          if (state.status == Status.error && state.message != null) {
            context.showSnackBar(state.message!, isError: true);
          }
          if (state.status == Status.success && state.message != null) {
            context.showSnackBar(state.message!);
            emailController.clear();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: CustomAppBar(
              title: SharePropertyText.appBar,
              isLeading: true,
            ),
            body: SafeArea(
              top: false,
              child: state.isSubmitting
                  ? AppShimmer.form()
                  : ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  SizedBox(height: 24.h),
                  SharePropertyHeader(entity: widget.cardEntity),
                  SizedBox(height: 24.h),
                  AppTField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    startIcon: Icons.email_outlined,
                    hintText: SharePropertyText.emailHint,
                    labelText: SharePropertyText.friendEmail,
                    onChanged: _onEmailChanged,
                  ),
                  SizedBox(height: 6.h),
                  ShareEmailLookupStatus(state: state),
                  SizedBox(height: 24.h),
                  ExtraSmallText(
                    text: SharePropertyText.permissions.toTitleCase(),
                  ),
                  SizedBox(height: 8.h),
                  ...SharePermissionItem.all.map(
                    (item) => SharePermissionTile(
                      item: item,
                      isSelected: state.permissions.contains(item.id),
                      onTap: () => context.read<SharePropertyBloc>().add(
                        ToggleSharePermissionEvent(permissionId: item.id),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ShareMembersCard(
                    members: state.members,
                    isLoading: state.isLoadingMembers,
                    onRemove: (member) => context.read<SharePropertyBloc>().add(
                      RemoveShareMemberEvent(
                        email: member.email,
                        uid: member.uid,
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Opacity(
                    opacity: state.canShare ? 1 : 0.45,
                    child: IgnorePointer(
                      ignoring: !state.canShare,
                      child: PrimaryButton(
                        text: state.isSubmitting
                            ? SharePropertyText.sharing
                            : SharePropertyText.shareWithFriend,
                        isDisable: state.isSubmitting,
                        onTap: () => context.read<SharePropertyBloc>().add(
                          SubmitSharePropertyEvent(
                            email: emailController.text.trim(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
