import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../movies/presentation/providers/movies_viewmodel.dart';

class LoginViewModel extends ChangeNotifier {
  late final LoginUser _loginUser;
  late final AuthRepository _authRepository;

  bool _isLoading = false;
  String? _errorMessage;

  LoginViewModel() {
    _initializeUseCases();
  }

  void _initializeUseCases() {
    final remoteDatasource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(remoteDatasource);
    _loginUser = LoginUser(repository);
    _authRepository = repository;
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

    final (sessionId, loginFailure) = await _loginUser.call(
      username: username,
      password: password,
    );

    if (loginFailure != null) {
      _setError(loginFailure.message);
      _setLoading(false);
      return;
    }

    final (user, userFailure) = await _authRepository.getAccountDetails(sessionId!);

    if (userFailure != null) {
      _setError(userFailure.message);
      _setLoading(false);
      return;
    }

    if (context.mounted) {
      final moviesViewModel = context.read<MoviesViewModel>();
      moviesViewModel.setSessionId(sessionId);
      moviesViewModel.setCurrentUser(user!);
      context.go('/movies');
    }
    _setLoading(false);
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