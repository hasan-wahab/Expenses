import 'package:expense_app/core/extensions/date_extension.dart';

import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_remote_repo_inter.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/constant/app_key/table_keys.dart';
import '../../../core/data_source/auth_data_source/auth_local_source.dart';
import '../../../core/data_source/auth_data_source/auth_remote_source.dart';

class AuthRepo implements AuthRemoteRepoInter {
  AuthRemoteSource authRemoteSource;
  AuthLocalSource authLocalSource;
  AuthRepo({required this.authRemoteSource, required this.authLocalSource});

  @override
  Future<void> createUser({required UserModel model}) async {
    await authRemoteSource.create(model: model);
  }

  @override
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    /// Login with email and password
    UserModel user = await authRemoteSource.login(
      email: email,
      password: password,
    );

    /// Save user in local storage
    await authLocalSource.save(model: user);

    /// Save user email in local storage
    await authLocalSource.saveCurrentUserEmail(email: email);

    return user;
  }

  @override
  Future<void> loginWithGoogleUser() {
    // TODO: implement loginWithGoogleUser
    throw UnimplementedError();
  }

  @override
  Future loginWithFingerPrint() async {
    try {
      LocalAuthentication local = LocalAuthentication();
      await local.authenticate(
        localizedReason: 'Use your fingerprint to log in',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
    } on LocalAuthException catch (e) {
      throw e.code;
    }
  }

  Future<bool> getFingerPrint() async {
    return await authLocalSource.getFingerPrint();
  }
}
