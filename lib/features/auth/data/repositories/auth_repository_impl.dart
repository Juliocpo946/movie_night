import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _localDatasource;

  AuthRepositoryImpl(this._localDatasource);

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = UserModel(
        name: name,
        email: email,
        password: password,
      );

      await _localDatasource.registerUser(userModel);
    } catch (e) {
      throw Exception('Error en el registro: ${e.toString()}');
    }
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _localDatasource.findUserByEmailAndPassword(
        email,
        password,
      );

      if (userModel == null) {
        throw Exception('Credenciales incorrectas');
      }

      return User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
      );
    } catch (e) {
      throw Exception('Error en el login: ${e.toString()}');
    }
  }

  @override
  Future<bool> emailExists(String email) async {
    try {
      return await _localDatasource.emailExists(email);
    } catch (e) {
      throw Exception('Error al verificar email: ${e.toString()}');
    }
  }
}