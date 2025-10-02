import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<(AuthResponseModel?, Failure?)> login({
    required String username,
    required String password,
  }) async {
    try {
      final authResponse = await remoteDatasource.login(username, password);
      return (authResponse, null);
    } on ServerException catch (e) {
      return (null, ServerFailure(message: e.message));
    }
  }

  @override
  Future<(User?, Failure?)> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDatasource.register(username, email, password);
      return (user, null);
    } on ServerException catch (e) {
      return (null, ServerFailure(message: e.message));
    }
  }
}