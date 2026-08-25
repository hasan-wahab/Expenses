import 'package:expense_app/core/data_source/properties_data_source/properties_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/share_property/domain/share_member_ui.dart';

class ShareRepo {
  final PropertiesRemoteSource remoteSource;
  final PropertiesLocalSource localSource;

  ShareRepo({
    required this.remoteSource,
    required this.localSource,
  });

  Future<List<ShareMemberUi>> getMembers({required int cardId}) {
    return remoteSource.getMembers(cardId: cardId);
  }

  Future shareWithFriend({
    required DashboardCardEntity card,
    required String friendUid,
    required String friendEmail,
    String? friendName,
    required List<String> permissions,
  }) async {
    final currentUserEmail = await localSource.getCurrentUserEmail();
    await remoteSource.shareWithFriend(
      model: PropertyModel.fromEntity(card),
      currentUserEmail: currentUserEmail,
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
    return remoteSource.unshareFriend(cardId: cardId, friendUid: friendUid);
  }
}
