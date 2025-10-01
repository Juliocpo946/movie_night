import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository _repository;

  LoginUser(this._repository);

  Future<String> call({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty) {
      throw Exception('El nombre de usuario es requerido');
    }
    if (password.trim().isEmpty) {
      throw Exception('La contraseña es requerida');
    }
    return await _repository.login(
      username: username.trim(),
      password: password,
    );
  }
}