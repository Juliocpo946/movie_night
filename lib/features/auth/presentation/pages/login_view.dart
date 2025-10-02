import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_theme.dart';
import '../providers/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildUsernameField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 24),
                _buildLoginButton(),
                const SizedBox(height: 16),
                _buildRegisterButton(),
                const SizedBox(height: 16),
                _buildErrorMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.movie_outlined,
          size: 80,
          color: AppTheme.vibrantAmber,
        ),
        const SizedBox(height: 16),
        Text(
          'Noche de Cine',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppTheme.vibrantAmber,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Inicia sesión o crea una cuenta',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'Nombre de usuario',
        prefixIcon: Icon(Icons.person_outline),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'El nombre de usuario es requerido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'La contraseña es requerida';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return ElevatedButton(
          onPressed: loginViewModel.isLoading ? null : _handleLogin,
          child: loginViewModel.isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Iniciar Sesión'),
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () {
        context.go('/register');
      },
      child: const Text('¿No tienes una cuenta? Créala aquí'),
    );
  }

  Widget _buildErrorMessage() {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        if (loginViewModel.errorMessage != null) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 0, 0, 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color.fromRGBO(255, 0, 0, 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    loginViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: loginViewModel.clearError,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginViewModel>().login(
        context: context,
        username: _usernameController.text,
        password: _passwordController.text,
      );
    }
  }
}