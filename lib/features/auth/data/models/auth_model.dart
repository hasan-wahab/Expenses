import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final int? id;
  final String? name;
  final String? email;

  final String? createAt;
  final String? updateAt;

  UserModel({this.id, this.email, this.name, this.createAt, this.updateAt});

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
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
    );
  }

  // Convert object to JSON
  String toJson() => json.encode(toMap());

  // Create object from JSON
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
