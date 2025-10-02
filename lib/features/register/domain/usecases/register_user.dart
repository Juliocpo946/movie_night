import '../../../../core/error/failures.dart';
import '../entities/registered_user.dart';
import '../repositories/register_repository.dart';

class RegisterUser {
  final RegisterRepository _repository;

  RegisterUser(this._repository);

  Future<(RegisteredUser?, Failure?)> call({
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