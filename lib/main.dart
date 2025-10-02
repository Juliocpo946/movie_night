import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/config/app_router.dart';
import 'core/config/app_theme.dart';
import 'features/auth/presentation/providers/login_viewmodel.dart';
import 'features/register/presentation/providers/register_viewmodel.dart';
import 'features/favorites/presentation/providers/favorites_viewmodel.dart';
import 'features/movies/presentation/providers/movies_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MoviesViewModel(),
        ),
        ChangeNotifierProxyProvider<MoviesViewModel, FavoritesViewModel>(
          create: (context) => FavoritesViewModel(),
          update: (context, moviesViewModel, favoritesViewModel) {
            favoritesViewModel!.updateCredentials(
              user: moviesViewModel.currentUser,
              sessionId: moviesViewModel.sessionId,
            );
            return favoritesViewModel;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Noche de Cine',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}