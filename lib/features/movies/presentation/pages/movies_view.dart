import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:no_screenshot/no_screenshot.dart';

import '../../../../core/config/app_theme.dart';
import '../../../favorites/presentation/providers/favorites_viewmodel.dart';
import '../providers/movies_viewmodel.dart';
import '../widgets/movie_grid.dart';
import '../widgets/search_bar_widget.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  final noscreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    noscreenshot.screenshotOff();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildSearchSection()),
            SliverToBoxAdapter(child: _buildErrorMessage()),
            const MovieGrid(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Icon(
            Icons.movie_outlined,
            color: AppTheme.vibrantAmber,
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text('Noche de Cine'),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moviesViewModel.currentUser?.name ?? 'Usuario',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.pureWhite,
                        ),
                      ),
                      Text(
                        moviesViewModel.currentUser?.email ?? '',
                        style: const TextStyle(
                          color: AppTheme.lightGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
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

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const SearchBarWidget(),
    );
  }

  Widget _buildErrorMessage() {
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