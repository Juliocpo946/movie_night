import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_view.dart';
import '../../features/movies/presentation/pages/movies_view.dart';
import '../../features/favorites/presentation/pages/favorites_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/movies',
        name: 'movies',
        builder: (context, state) => const MoviesView(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesView(),
      ),
    ],
  );
}