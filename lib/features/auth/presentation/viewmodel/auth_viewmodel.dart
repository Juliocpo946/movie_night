import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/database_helper.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';

class AuthViewModel extends ChangeNotifier {
  late final RegisterUser _registerUser;
  late final LoginUser _loginUser;

  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  AuthViewModel() {
    _initializeUseCases();
  }

  void _initializeUseCases() {
    final databaseHelper = DatabaseHelper();
    final localDatasource = AuthLocalDatasource(databaseHelper);
    final repository = AuthRepositoryImpl(localDatasource);

    _registerUser = RegisterUser(repository);
    _loginUser = LoginUser(repository);
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _registerUser.call(
        name: name,
        email: email,
        password: password,
      );

      if (context.mounted) {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso. Ahora puedes iniciar sesión.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
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

      _currentUser = user;

      if (context.mounted) {
        context.go('/movies');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void logout(BuildContext context) {
    _currentUser = null;
    notifyListeners();
    context.go('/login');
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