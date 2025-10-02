import '../../../../core/error/failures.dart';
import '../entities/login_response.dart';

abstract class AuthRepository {
  Future<(LoginResponse?, Failure?)> login({
    required String username,
    required String password,
  });
}