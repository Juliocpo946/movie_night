import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../domain/entities/registered_user.dart';
import '../../domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final AuthRemoteDatasource remoteDatasource;

  RegisterRepositoryImpl(this.remoteDatasource);

  @override
  Future<(RegisteredUser?, Failure?)> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDatasource.register(username, email, password);
      final registeredUser = RegisteredUser(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
      );
      return (registeredUser, null);
    } on ServerException catch (e) {
      return (null, ServerFailure(message: e.message));
    }
  }
}