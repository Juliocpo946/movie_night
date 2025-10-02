import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository _repository;

  RegisterUser(this._repository);

  Future<(User?, Failure?)> call({
    required String username,
    required String email,
    required String password,
  }) async {
    if (username.trim().isEmpty) {
      return (null, ValidationFailure(message: 'El nombre de usuario es requerido'));
    }
    if (email.trim().isEmpty) {
      return (null, ValidationFailure(message: 'El correo es requerido'));
    }
    if (password.trim().isEmpty) {
      return (null, ValidationFailure(message: 'La contraseña es requerida'));
    }
    return await _repository.register(
      username: username.trim(),
      email: email.trim(),
      password: password,
    );
  }
}