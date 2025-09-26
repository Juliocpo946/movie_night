import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/movies_viewmodel.dart';
import 'movie_poster_card.dart';

class MovieGrid extends StatelessWidget {
  const MovieGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesViewModel>(
      builder: (context, moviesViewModel, child) {
        final movies = moviesViewModel.searchQuery.isNotEmpty
            ? moviesViewModel.searchResults
            : moviesViewModel.popularMovies;

        // Si está cargando por primera vez y no hay películas, muestra un indicador de carga
        if (moviesViewModel.isLoading && movies.isEmpty) {
          return const SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando películas...'),
                ],
              ),
            ),
          );
        }

        // Si no hay películas y no está cargando, muestra el estado vacío
        if (movies.isEmpty && !moviesViewModel.isLoading) {
          return SliverFillRemaining(
            child: _buildEmptyState(moviesViewModel),
          );
        }

        // Paginación: escucha las notificaciones de scroll
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!moviesViewModel.isLoading &&
                moviesViewModel.hasMorePages &&
                scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {

              // Carga más películas solo si no hay una búsqueda activa
              if (moviesViewModel.searchQuery.isEmpty) {
                context.read<MoviesViewModel>().loadPopularMovies(loadMore: true);
              }
            }
            return true;
          },
          child: SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  // Si llegamos al final de la lista y hay más páginas, mostramos un loader
                  if (index == movies.length && moviesViewModel.hasMorePages && moviesViewModel.searchQuery.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return MoviePosterCard(movie: movies[index]);
                },
                // Añadimos 1 al count si hay más páginas para mostrar el loader
                childCount: movies.length + (moviesViewModel.hasMorePages && moviesViewModel.searchQuery.isEmpty ? 1 : 0),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(MoviesViewModel moviesViewModel) {
    // ... (Este método no cambia)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            moviesViewModel.searchQuery.isNotEmpty
                ? Icons.search_off
                : Icons.movie_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            moviesViewModel.searchQuery.isNotEmpty
                ? 'No se encontraron películas para "${moviesViewModel.searchQuery}"'
                : 'No hay películas disponibles',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          if (moviesViewModel.searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: moviesViewModel.clearSearch,
              child: const Text('Ver películas populares'),
            ),
          ],
        ],
      ),
    );
  }
}