import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    final requestToken = await remoteDatasource.createRequestToken();
    final validatedToken = await remoteDatasource.validateTokenWithLogin(
      username,
      password,
      requestToken,
    );
    final sessionId = await remoteDatasource.createSession(validatedToken);
    return sessionId;
  }

  @override
  Future<User> getAccountDetails(String sessionId) async {
    return await remoteDatasource.getAccountDetails(sessionId);
  }
}