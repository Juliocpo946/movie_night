import '../../../../core/error/failures.dart';
import '../entities/registered_user.dart';

abstract class RegisterRepository {
  Future<(RegisteredUser?, Failure?)> register({
    required String username,
    required String email,
    required String password,
  });
}