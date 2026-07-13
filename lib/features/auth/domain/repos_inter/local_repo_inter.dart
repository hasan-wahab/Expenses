import 'package:expense_app/features/auth/data/models/auth_model.dart';

abstract class AuthLocalRepoInter {
  Future saveCurrentUser({required UserModel model});

  Future<UserModel> getCurrentUser({required String email});

  Future<bool> deleteCurrentUser({required UserModel model});
}
