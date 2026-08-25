import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/core/utils/profile_image_utils.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:expense_app/features/auth/domain/repos_inter/auth_remote_repo_inter.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/data_source/auth_data_source/auth_local_source.dart';
import '../../../core/data_source/auth_data_source/auth_remote_source.dart';

class AuthRepo implements AuthRemoteRepoInter {
  AuthRemoteSource authRemoteSource;
  AuthLocalSource authLocalSource;
  AuthRepo({required this.authRemoteSource, required this.authLocalSource});

  @override
  Future<void> createUser({required UserModel model}) async {
    await authRemoteSource.create(model: model);
    await authLocalSource.save(model: model);
    await authLocalSource.saveCurrentUserEmail(email: model.email.toString());
    /// After signup, user must login explicitly on Login screen.
    await authLocalSource.setRequiresLogin();

    /// EMAIL VERIFICATION DISABLED — uncomment to send verify email on signup again.
    // /// Send after account is ready. Failure must not block signup —
    // /// VerifyEmailScreen will retry and show the real error.
    // try {
    //   await authRemoteSource.sendEmailVerification();
    // } catch (_) {}
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

    final loginEmail = email.trim();
    final savedEmail = await authLocalSource.getCurrentUserEmailOrNull();

    /// Different account → clear old saved email, then save new one
    if (savedEmail != null &&
        savedEmail.trim().toLowerCase() != loginEmail.toLowerCase()) {
      await authLocalSource.delete();
    }

    /// Prefer Firestore https image / valid local file; else Google Auth photoURL
    String? previousImage;
    try {
      previousImage = (await authLocalSource.get(email: loginEmail)).imageUrl;
    } catch (_) {}

    final imageUrl = resolveProfileImageUrl(
      storedImageUrl: user.imageUrl.orEmpty.isNotEmpty
          ? user.imageUrl
          : previousImage,
      networkFallbackUrl: authRemoteSource.photoUrl,
    );
    user = user.copyWith(imageUrl: imageUrl);

    /// Save user in local storage
    await authLocalSource.save(model: user);

    /// Save / keep current user email
    await authLocalSource.saveCurrentUserEmail(email: loginEmail);
    await authLocalSource.clearRequiresLogin();

    return user;
  }

  Future<bool> isEmailVerified() async {
    return authRemoteSource.isEmailVerified;
  }

  Future<String?> getCurrentAuthEmail() async {
    return authRemoteSource.currentUserEmail;
  }

  Future<void> sendEmailVerification() async {
    await authRemoteSource.sendEmailVerification();
  }

  Future<bool> reloadAndCheckEmailVerified() async {
    return await authRemoteSource.reloadAndCheckEmailVerified();
  }

  @override
  Future<void> loginWithGoogleUser() {
    // TODO: implement loginWithGoogleUser
    throw UnimplementedError();
  }

  @override
  Future loginWithFingerPrint() async {
    final savedEmail = await authLocalSource.getCurrentUserEmailOrNull();
    if (savedEmail == null) {
      throw 'Login first, then enable fingerprint in Settings.';
    }

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

    /// Biometric alone is not Firebase Auth. Session must still exist
    /// (kept on local logout — no Firebase signOut).
    if (authRemoteSource.currentUser == null) {
      throw 'Session expired. Please login with email and password.';
    }
    await authLocalSource.clearRequiresLogin();
    try {
      final local = await authLocalSource.get(email: savedEmail);
      await authRemoteSource.ensureUserDoc(local: local);
    } catch (e) {
      // Fingerprint login should still succeed if profile write fails.
    }
  }

  Future<bool> getFingerPrint() async {
    return await authLocalSource.getFingerPrint();
  }

  Future<String?> getSavedEmail() async {
    return await authLocalSource.getCurrentUserEmailOrNull();
  }

  Future<bool> hasValidSession() async {
    if (authRemoteSource.currentUser == null) return false;
    /// EMAIL VERIFICATION DISABLED — uncomment to require verified email for session.
    // if (!authRemoteSource.isEmailVerified) return false;
    final email = await authLocalSource.getCurrentUserEmailOrNull();
    return email != null && email.isNotEmpty;
  }

  Future<bool> requiresLogin() async {
    return await authLocalSource.requiresLogin();
  }

  Future<void> logout() async {
    /// Local logout only — DO NOT Firebase.signOut().
    /// Next app open / this navigation shows Login until user logs in again.
    await authLocalSource.setRequiresLogin();
  }
}
