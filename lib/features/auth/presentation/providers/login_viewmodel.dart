import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/domain/entities/user.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_user.dart';
import '../../../movies/presentation/providers/movies_viewmodel.dart';

class LoginViewModel extends ChangeNotifier {
  late final LoginUser _loginUser;

  bool _isLoading = false;
  String? _errorMessage;

  LoginViewModel() {
    _initializeUseCases();
  }

  void _initializeUseCases() {
    final remoteDatasource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(remoteDatasource);
    _loginUser = LoginUser(repository);
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    final (loginResponse, loginFailure) = await _loginUser.call(
      username: username,
      password: password,
    );

    _setLoading(false);

    if (loginFailure != null) {
      _setError(loginFailure.message);
      return;
    }

    if (loginResponse != null) {
      if (!context.mounted) return;

      final moviesViewModel = context.read<MoviesViewModel>();
      moviesViewModel.setSessionId(loginResponse.accessToken);

      final sharedUser = User(
        id: loginResponse.user.id,
        name: loginResponse.user.name,
        email: '',
      );

      moviesViewModel.setCurrentUser(sharedUser);
      context.go('/movies');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
  }

  void _clearError() {
    _errorMessage = null;
  }
}