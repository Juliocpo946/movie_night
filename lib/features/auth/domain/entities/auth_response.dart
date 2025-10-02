import 'auth_user.dart';

class AuthResponse {
  final String accessToken;
  final AuthUser user;

  const AuthResponse({
    required this.accessToken,
    required this.user,
  });
}