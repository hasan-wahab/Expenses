import 'package:expense_app/core/data_source/auth_data_source/auth_remote_source.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/share_property/data/share_repo.dart';
import 'package:expense_app/features/share_property/domain/share_member_ui.dart';

class SharePropertyUseCases {
  final ShareRepo shareRepo;
  final AuthRemoteSource authRemoteSource;

  SharePropertyUseCases({
    required this.shareRepo,
    required this.authRemoteSource,
  });

  String? get currentUserEmail => authRemoteSource.currentUserEmail;

  Future<Map<String, dynamic>?> findRegisteredUserByEmail(String email) {
    return authRemoteSource.findRegisteredUserByEmail(email);
  }

  Future<List<ShareMemberUi>> getMembers({required int cardId}) {
    return shareRepo.getMembers(cardId: cardId);
  }

  Future shareWithFriend({
    required DashboardCardEntity card,
    required String friendUid,
    required String friendEmail,
    String? friendName,
    required List<String> permissions,
  }) {
    return shareRepo.shareWithFriend(
      card: card,
      friendUid: friendUid,
      friendEmail: friendEmail,
      friendName: friendName,
      permissions: permissions,
    );
  }

  Future unshareFriend({
    required int cardId,
    required String friendUid,
  }) {
    return shareRepo.unshareFriend(cardId: cardId, friendUid: friendUid);
  }
}
