import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/database_helper.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/register_user.dart';

class RegisterViewModel extends ChangeNotifier {
  late final RegisterUser _registerUser;

  bool _isLoading = false;
  String? _errorMessage;

  RegisterViewModel() {
    _initializeUseCases();
  }

  void _initializeUseCases() {
    final databaseHelper = DatabaseHelper();
    final localDatasource = AuthLocalDatasource(databaseHelper);
    final repository = AuthRepositoryImpl(localDatasource);
    _registerUser = RegisterUser(repository);
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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