import 'package:bloc/bloc.dart';
import 'package:expense_app/core/constant/const_text/share_property_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/share_property/domain/share_member_ui.dart';
import 'package:expense_app/features/share_property/domain/share_permission_item.dart';
import 'package:expense_app/features/share_property/domain/share_property_use_cases.dart';
import 'package:expense_app/features/share_property/presentation/bloc/share_property_events.dart';
import 'package:expense_app/features/share_property/presentation/bloc/share_property_states.dart';

class SharePropertyBloc extends Bloc<SharePropertyEvents, SharePropertyState> {
  final SharePropertyUseCases useCases;
  DashboardCardEntity? _card;

  SharePropertyBloc({required this.useCases}) : super(SharePropertyState()) {
    on<LoadShareMembersEvent>(_onLoadMembers);
    on<ShareEmailChangedEvent>(_onEmailChanged);
    on<ToggleSharePermissionEvent>(_onTogglePermission);
    on<SubmitSharePropertyEvent>(_onSubmit);
    on<RemoveShareMemberEvent>(_onRemoveMember);
  }

  Future<void> _onLoadMembers(
    LoadShareMembersEvent event,
    Emitter<SharePropertyState> emit,
  ) async {
    _card = event.card;
    emit(
      state.copyWith(
        isLoadingMembers: true,
        status: Status.initial,
        clearMessage: true,
      ),
    );
    if (!await InternetUtils.hasInternetAccess()) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          isLoadingMembers: false,
          status: Status.error,
          message: SharePropertyText.needInternet,
        ),
      );
      return;
    }
    try {
      final members = await useCases.getMembers(cardId: event.card.cardId);
      if (emit.isDone) return;
      emit(state.copyWith(members: members, isLoadingMembers: false));
    } catch (_) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          isLoadingMembers: false,
          status: Status.error,
          message: SharePropertyText.membersLoadFailed,
        ),
      );
    }
  }

  Future<void> _onEmailChanged(
    ShareEmailChangedEvent event,
    Emitter<SharePropertyState> emit,
  ) async {
    final email = event.email.trim().toLowerCase();
    if (email.isEmpty || !_isValidEmail(email)) {
      emit(
        state.copyWith(
          emailLookup: ShareEmailLookup.idle,
          clearFoundUser: true,
        ),
      );
      return;
    }

    final myEmail = useCases.currentUserEmail?.trim().toLowerCase();
    if (myEmail != null && myEmail == email) {
      emit(
        state.copyWith(
          emailLookup: ShareEmailLookup.ownEmail,
          clearFoundUser: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        emailLookup: ShareEmailLookup.searching,
        clearFoundUser: true,
      ),
    );

    if (!await InternetUtils.hasInternetAccess()) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          emailLookup: ShareEmailLookup.offline,
          clearFoundUser: true,
        ),
      );
      return;
    }

    try {
      final data = await useCases.findRegisteredUserByEmail(email);
      if (emit.isDone) return;
      if (data == null) {
        emit(
          state.copyWith(
            emailLookup: ShareEmailLookup.notFound,
            clearFoundUser: true,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          emailLookup: ShareEmailLookup.found,
          foundUser: ShareMemberUi(
            uid: data['uid']?.toString(),
            name: data['name']?.toString(),
            email: data['email']?.toString() ?? email,
            permissions: const [],
          ),
        ),
      );
    } catch (_) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          emailLookup: ShareEmailLookup.notFound,
          clearFoundUser: true,
        ),
      );
    }
  }

  void _onTogglePermission(
    ToggleSharePermissionEvent event,
    Emitter<SharePropertyState> emit,
  ) {
    if (event.permissionId == SharePermissionItem.viewSummary) return;
    final next = {...state.permissions};
    if (next.contains(event.permissionId)) {
      next.remove(event.permissionId);
    } else {
      next.add(event.permissionId);
    }
    next.add(SharePermissionItem.viewSummary);
    emit(
      state.copyWith(
        permissions: next,
        status: Status.initial,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onSubmit(
    SubmitSharePropertyEvent event,
    Emitter<SharePropertyState> emit,
  ) async {
    final card = _card;
    final email = event.email.trim().toLowerCase();
    if (card == null) {
      emit(
        state.copyWith(
          status: Status.error,
          message: SharePropertyText.shareFailed,
        ),
      );
      return;
    }
    if (email.isEmpty) {
      emit(
        state.copyWith(
          status: Status.error,
          message: SharePropertyText.emailRequired,
        ),
      );
      return;
    }
    if (state.emailLookup == ShareEmailLookup.ownEmail) {
      emit(
        state.copyWith(
          status: Status.error,
          message: SharePropertyText.cannotShareSelf,
        ),
      );
      return;
    }
    if (state.emailLookup == ShareEmailLookup.searching || state.isSubmitting) {
      return;
    }
    if (!state.canShare) {
      emit(
        state.copyWith(
          status: Status.error,
          message: SharePropertyText.emailNotValid,
        ),
      );
      return;
    }
    final found = state.foundUser!;
    final friendUid = found.uid?.trim() ?? '';
    if (friendUid.isEmpty || friendUid.contains('@')) {
      emit(
        state.copyWith(
          status: Status.error,
          message: SharePropertyText.askFriendOpenApp,
        ),
      );
      return;
    }
    final already = state.members.any(
      (m) =>
          m.email.toLowerCase() == email ||
          (m.uid != null && m.uid == friendUid),
    );
    if (already) {
      emit(
        state.copyWith(
          status: Status.error,
          message: SharePropertyText.alreadyShared,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        status: Status.loading,
        clearMessage: true,
      ),
    );
    if (!await InternetUtils.hasInternetAccess()) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          isSubmitting: false,
          status: Status.error,
          message: SharePropertyText.needInternet,
        ),
      );
      return;
    }
    try {
      await useCases.shareWithFriend(
        card: card,
        friendUid: friendUid,
        friendEmail: found.email,
        friendName: found.name,
        permissions: state.permissions.toList(),
      );
      final members = await useCases.getMembers(cardId: card.cardId);
      if (emit.isDone) return;
      emit(
        SharePropertyState(
          members: members,
          status: Status.success,
          message: '${SharePropertyText.sharedWith} ${found.email}',
        ),
      );
    } catch (e) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          isSubmitting: false,
          status: Status.error,
          message: _errorMessage(e),
        ),
      );
    }
  }

  Future<void> _onRemoveMember(
    RemoveShareMemberEvent event,
    Emitter<SharePropertyState> emit,
  ) async {
    final card = _card;
    if (card == null || state.isSubmitting) return;
    final friendUid = (event.uid != null && event.uid!.isNotEmpty)
        ? event.uid!
        : (state.members
                  .where(
                    (m) => m.email.toLowerCase() == event.email.toLowerCase(),
                  )
                  .map((m) => m.uid)
                  .firstWhere(
                    (id) => id != null && id.isNotEmpty,
                    orElse: () => null,
                  ) ??
              '');
    if (friendUid.isEmpty) {
      emit(
        state.copyWith(
          status: Status.error,
          message: SharePropertyText.shareFailed,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        status: Status.loading,
        clearMessage: true,
      ),
    );
    if (!await InternetUtils.hasInternetAccess()) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          isSubmitting: false,
          status: Status.error,
          message: SharePropertyText.needInternet,
        ),
      );
      return;
    }
    try {
      await useCases.unshareFriend(cardId: card.cardId, friendUid: friendUid);
      final members = await useCases.getMembers(cardId: card.cardId);
      if (emit.isDone) return;
      emit(
        state.copyWith(
          members: members,
          isSubmitting: false,
          status: Status.success,
          message: SharePropertyText.memberRemoved,
        ),
      );
    } catch (e) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          isSubmitting: false,
          status: Status.error,
          message: _errorMessage(e),
        ),
      );
    }
  }

  String _errorMessage(Object error) {
    final text = error.toString().replaceFirst('Exception: ', '');
    if (text.trim().isEmpty) return SharePropertyText.shareFailed;
    return text;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}
