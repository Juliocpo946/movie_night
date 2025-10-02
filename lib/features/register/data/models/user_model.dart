import '../../domain/entities/registered_user.dart';

class UserModel extends RegisteredUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['username'] as String,
      email: json['email'] as String,
    );
  }
}