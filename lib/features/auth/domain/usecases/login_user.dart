import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository _repository;

  LoginUser(this._repository);

  Future<User> call({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) {
      throw Exception('El email es requerido');
    }

    if (password.trim().isEmpty) {
      throw Exception('La contraseña es requerida');
    }

    return await _repository.login(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }
}