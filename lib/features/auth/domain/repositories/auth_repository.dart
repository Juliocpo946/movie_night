import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<(String?, Failure?)> login({
    required String username,
    required String password,
  });

  Future<(User?, Failure?)> getAccountDetails(String sessionId);
}