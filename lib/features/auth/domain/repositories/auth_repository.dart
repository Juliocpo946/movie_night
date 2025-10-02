import '../../../../core/error/failures.dart';
import '../../data/models/auth_response_model.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<(AuthResponseModel?, Failure?)> login({
    required String username,
    required String password,
  });

  Future<(User?, Failure?)> register({
    required String username,
    required String email,
    required String password,
  });
}