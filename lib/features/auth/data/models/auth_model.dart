import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/features/auth/domain/entitity/auth_entity.dart';

class UserModel extends AuthEntity {
  final int? id;
  final String? createAt;
  final String? updateAt;

  UserModel({
    this.id,
    super.name,
    super.email,
    super.password,
    super.loginWith,
    this.createAt,
    this.updateAt,
  });

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'loginWith': loginWith,
      'createAt': createAt,
      'updateAt': updateAt,
    };
  }

  // Create object from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createAt: map['createAt'],
      updateAt: map['updateAt'],
      loginWith: map['loginWith'],
    );
  }

  /// 🔹 Entity → Model
  factory UserModel.fromEntity(AuthEntity entity) {
    return UserModel(
      name: entity.name,
      email: entity.email,
      password: entity.password,
      loginWith: entity.loginWith,
      createAt: DateTime.now().toIso8601String(),
    );
  }

  /// 🔹 Model → Entity
  AuthEntity toEntity() {
    return AuthEntity(
      name: name,
      email: email,
      password: password,
      loginWith: loginWith,
    );
  }

  // Convert object to JSON
  String toJson() => json.encode(toMap());

  // Create object from JSON
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
