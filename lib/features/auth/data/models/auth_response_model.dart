import '../../domain/entities/auth_user.dart';
import '../../domain/entities/login_response.dart';

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

  LoginResponse toEntity() {
    return LoginResponse(
      accessToken: accessToken,
      user: AuthUser(
        id: userId,
        name: username,
      ),
    );
  }
}