import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository _repository;

  RegisterUser(this._repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception('El nombre es requerido');
    }

    if (email.trim().isEmpty) {
      throw Exception('El email es requerido');
    }

    if (!_isValidEmail(email)) {
      throw Exception('El formato del email no es válido');
    }

    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }

    final emailExists = await _repository.emailExists(email);
    if (emailExists) {
      throw Exception('El email ya está registrado');
    }

    await _repository.register(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}