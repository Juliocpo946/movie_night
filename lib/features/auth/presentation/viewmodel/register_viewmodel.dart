import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:no_screenshot/no_screenshot.dart';
import '../../../../core/config/theme.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final noscreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    noscreenshot.screenshotOff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.person_add_outlined,
                size: 60,
                color: AppTheme.vibrantAmber,
              ),
              const SizedBox(height: 16),
              Text(
                'Únete a The Movie Database',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.pureWhite,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Esta aplicación utiliza el servicio de TMDB. Por favor, crea una cuenta en su sitio web oficial. Luego, regresa a esta pantalla para iniciar sesión.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                },
                child: const Text('Ir al sitio de TMDB'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Ya tengo una cuenta',
                  style: TextStyle(color: AppTheme.vibrantAmber),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}