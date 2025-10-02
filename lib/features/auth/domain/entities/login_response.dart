import 'auth_user.dart';

class LoginResponse {
  final String accessToken;
  final AuthUser user;

  const LoginResponse({
    required this.accessToken,
    required this.user,
  });
}