import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository _repository;

  RegisterUser(this._repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) async {
    // Esta funcionalidad ya no es necesaria, el registro se hace en TMDB.
    // Se deja el archivo para evitar errores de importación, pero la lógica se ha removido.
    throw Exception('El registro se realiza directamente en el sitio web de TMDB.');
  }
}