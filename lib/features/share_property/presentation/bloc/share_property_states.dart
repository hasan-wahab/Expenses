import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/share_property/domain/share_member_ui.dart';
import 'package:expense_app/features/share_property/domain/share_permission_item.dart';

class SharePropertyState {
  final Set<String> permissions;
  final List<ShareMemberUi> members;
  final Status status;
  final String? message;
  final ShareEmailLookup emailLookup;
  final ShareMemberUi? foundUser;
  final bool isLoadingMembers;
  final bool isSubmitting;

  bool get canShare =>
      emailLookup == ShareEmailLookup.found &&
      foundUser != null &&
      !isSubmitting;

  SharePropertyState({
    Set<String>? permissions,
    this.members = const [],
    this.status = Status.initial,
    this.message,
    this.emailLookup = ShareEmailLookup.idle,
    this.foundUser,
    this.isLoadingMembers = false,
    this.isSubmitting = false,
  }) : permissions = permissions ?? {SharePermissionItem.viewSummary};

  SharePropertyState copyWith({
    Set<String>? permissions,
    List<ShareMemberUi>? members,
    Status? status,
    String? message,
    bool clearMessage = false,
    ShareEmailLookup? emailLookup,
    ShareMemberUi? foundUser,
    bool clearFoundUser = false,
    bool? isLoadingMembers,
    bool? isSubmitting,
  }) {
    return SharePropertyState(
      permissions: permissions ?? this.permissions,
      members: members ?? this.members,
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
      emailLookup: emailLookup ?? this.emailLookup,
      foundUser: clearFoundUser ? null : (foundUser ?? this.foundUser),
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
