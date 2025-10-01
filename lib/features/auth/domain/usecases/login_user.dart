import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository _repository;

  LoginUser(this._repository);

  Future<(String?, Failure?)> call({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty) {
      return (null, ValidationFailure(message: 'El nombre de usuario es requerido'));
    }
    if (password.trim().isEmpty) {
      return (null, ValidationFailure(message: 'La contraseña es requerida'));
    }
    return await _repository.login(
      username: username.trim(),
      password: password,
    );
  }
}