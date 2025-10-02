import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/registered_user.dart';
import '../../domain/repositories/register_repository.dart';
import '../datasources/register_remote_datasource.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDatasource remoteDatasource;

  RegisterRepositoryImpl(this.remoteDatasource);

  @override
  Future<(RegisteredUser?, Failure?)> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDatasource.register(username, email, password);
      return (userModel, null);
    } on ServerException catch (e) {
      return (null, ServerFailure(message: e.message));
    }
  }
}