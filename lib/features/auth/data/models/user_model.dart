import '../../domain/entities/auth_user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}