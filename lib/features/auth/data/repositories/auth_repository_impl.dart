import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<(LoginResponse?, Failure?)> login({
    required String username,
    required String password,
  }) async {
    try {
      final authResponseModel = await remoteDatasource.login(username, password);
      return (authResponseModel.toEntity(), null);
    } on ServerException catch (e) {
      return (null, ServerFailure(message: e.message));
    }
  }
}