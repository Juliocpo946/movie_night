import '../entities/user.dart';

abstract class AuthRepository {
  Future<String> login({
    required String username,
    required String password,
  });

  Future<User> getAccountDetails(String sessionId);
}