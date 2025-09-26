import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/theme.dart';
import '../../../auth/presentation/viewmodel/auth_viewmodel.dart';
import '../viewmodel/movies_viewmodel.dart';
import '../widgets/movie_grid.dart';
import '../widgets/search_bar_widget.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Screenshot blocking removido temporalmente por compatibilidad
    _setupScrollListener();
  }

  @override
  void dispose() {
    // Screenshot blocking removido temporalmente por compatibilidad
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final moviesViewModel = context.read<MoviesViewModel>();
        if (!moviesViewModel.isLoading &&
            moviesViewModel.hasMorePages &&
            moviesViewModel.searchQuery.isEmpty) {
          moviesViewModel.loadPopularMovies(loadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildErrorMessage(),
          Expanded(
            child: _buildMoviesContent(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Icon(
            Icons.movie_outlined,
            color: AppTheme.vibrantAmber,
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text('Noche de Cine'),
        ],
      ),
      actions: [
        Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            return PopupMenuButton<String>(
              icon: CircleAvatar(
                backgroundColor: AppTheme.vibrantAmber,
                child: Text(
                  authViewModel.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    color: AppTheme.midnightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onSelected: (value) {
                if (value == 'logout') {
                  authViewModel.logout(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authViewModel.currentUser?.name ?? 'Usuario',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.pureWhite,
                        ),
                      ),
                      Text(
                        authViewModel.currentUser?.email ?? '',
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
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  onPressed: moviesViewModel.clearError,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMoviesContent() {
    return Consumer<MoviesViewModel>(
      builder: (context, moviesViewModel, child) {
        return RefreshIndicator(
          onRefresh: moviesViewModel.refresh,
          child: MovieGrid(
            scrollController: _scrollController,
          ),
        );
      },
    );
  }
}