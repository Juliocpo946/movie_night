import '../entities/user.dart';

abstract class AuthRepository {
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<User> login({
    required String email,
    required String password,
  });

  Future<bool> emailExists(String email);
}