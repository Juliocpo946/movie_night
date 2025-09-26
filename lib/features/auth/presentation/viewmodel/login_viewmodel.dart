import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/database_helper.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_user.dart';
import '../../../movies/presentation/viewmodel/movies_viewmodel.dart';

class LoginViewModel extends ChangeNotifier {
  late final LoginUser _loginUser;

  bool _isLoading = false;
  String? _errorMessage;

  LoginViewModel() {
    _initializeUseCases();
  }

  void _initializeUseCases() {
    final databaseHelper = DatabaseHelper();
    final localDatasource = AuthLocalDatasource(databaseHelper);
    final repository = AuthRepositoryImpl(localDatasource);
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
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _loginUser.call(
        email: email,
        password: password,
      );

      if (context.mounted) {
        // Actualiza el usuario en MoviesViewModel
        context.read<MoviesViewModel>().setCurrentUser(user);
        context.go('/movies');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}