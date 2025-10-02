import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasources/register_remote_datasource.dart';
import '../../data/repositories/register_repository_impl.dart';
import '../../domain/usecases/register_user.dart';

class RegisterViewModel extends ChangeNotifier {
  late final RegisterUser _registerUser;

  bool _isLoading = false;
  String? _errorMessage;

  RegisterViewModel() {
    final remoteDatasource = RegisterRemoteDatasource();
    final repository = RegisterRepositoryImpl(remoteDatasource);
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
    required String username,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    clearError();

    final (user, failure) = await _registerUser.call(
      username: username,
      email: email,
      password: password,
    );

    _setLoading(false);

    if (failure != null) {
      _setError(failure.message);
    } else if (user != null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario creado con éxito')),
      );
      context.go('/login');
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
}