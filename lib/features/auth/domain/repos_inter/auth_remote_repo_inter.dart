import 'package:expense_app/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteRepoInter {
  Future<void> createUser({required UserModel model});
  Future<UserModel> loginUser({
    required String email,
    required String password,
  });
  Future<void> loginWithGoogleUser();
  Future<void> loginWithFingerPrint();
}
