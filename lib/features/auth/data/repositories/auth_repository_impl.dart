import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<(String?, Failure?)> login({
    required String username,
    required String password,
  }) async {
    try {
      final requestToken = await remoteDatasource.createRequestToken();
      final validatedToken = await remoteDatasource.validateTokenWithLogin(
        username,
        password,
        requestToken,
      );
      final sessionId = await remoteDatasource.createSession(validatedToken);
      return (sessionId, null);
    } on ServerException catch (e) {
      return (null, ServerFailure(message: e.message));
    }
  }

  @override
  Future<(User?, Failure?)> getAccountDetails(String sessionId) async {
    try {
      final user = await remoteDatasource.getAccountDetails(sessionId);
      return (user, null);
    } on ServerException catch (e) {
      return (null, ServerFailure(message: e.message));
    }
  }
}