import '../../domain/entities/user.dart';

class AuthResponseModel {
  final String accessToken;
  final int userId;
  final String username;

  AuthResponseModel({
    required this.accessToken,
    required this.userId,
    required this.username,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'],
      userId: json['user_id'],
      username: json['username'],
    );
  }

  User toEntity() {
    return User(
      id: userId,
      name: username,
      email: '',
    );
  }
}