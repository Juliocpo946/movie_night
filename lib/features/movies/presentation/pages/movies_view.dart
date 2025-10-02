import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_theme.dart';
import '../../../favorites/presentation/providers/favorites_viewmodel.dart';
import '../providers/movies_viewmodel.dart';
import '../widgets/movie_grid.dart';
import '../widgets/popular_movies_carousel.dart';
import '../widgets/search_bar_widget.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Se obtienen los favoritos al iniciar la pantalla
      context.read<FavoritesViewModel>().fetchFavorites();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<MoviesViewModel>().refresh();
          await context.read<FavoritesViewModel>().fetchFavorites();
        },
        child: const CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SearchBarWidget()),
            SliverToBoxAdapter(child: PopularMoviesCarousel()),
            SliverToBoxAdapter(child: _ErrorMessage()),
            MovieGrid(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Row(
        children: [
          Icon(
            Icons.movie_outlined,
            color: AppTheme.vibrantAmber,
            size: 28,
          ),
          SizedBox(width: 8),
          Text('Noche de Cine'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: AppTheme.lightGray),
          onPressed: () => context.push('/favorites'),
        ),
        Consumer<MoviesViewModel>(
          builder: (context, moviesViewModel, child) {
            return PopupMenuButton<String>(
              icon: CircleAvatar(
                backgroundColor: AppTheme.vibrantAmber,
                child: Text(
                  moviesViewModel.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    color: AppTheme.midnightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onSelected: (value) {
                if (value == 'logout') {
                  context.read<FavoritesViewModel>().clearFavorites();
                  moviesViewModel.logout(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    moviesViewModel.currentUser?.name ?? 'Usuario',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.pureWhite,
                    ),
                  ),
                ),
                // --- FIN DE LA CORRECCIÓN ---
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: AppTheme.lightGray),
                      SizedBox(width: 8),
                      Text('Cerrar Sesión'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// Se ha movido la lógica del mensaje de error a su propio widget para mejorar la legibilidad.
class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesViewModel>(
      builder: (context, moviesViewModel, child) {
        if (moviesViewModel.errorMessage != null) {
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    moviesViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: context.read<MoviesViewModel>().clearError,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}