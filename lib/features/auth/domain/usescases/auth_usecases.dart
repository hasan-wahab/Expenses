import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/auth/data/auth_repo.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:expense_app/features/auth/domain/entitity/auth_entity.dart';

class AuthUseCases {
  AuthRepo repo;
  AuthUseCases({required this.repo});

  Future<void> createCall({required AuthEntity entityModel}) async {
    await repo.createUser(model: UserModel.fromEntity(entityModel));
  }

  Future<UserModel> loginCall({required String email, password}) async {
    return await repo.loginUser(email: email, password: password);
  }

  Future<void> loginWithFingerPrintCall() async {
    await repo.loginWithFingerPrint();
  }

  bool obscurePasswordCall({bool isObscure = true}) {
    return isObscure = !isObscure;
  }

  Future getFingerPrintCall() async {
    return await repo.getFingerPrint();
  }
}
