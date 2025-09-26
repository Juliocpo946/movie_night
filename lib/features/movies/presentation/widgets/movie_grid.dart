import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/movies_viewmodel.dart';
import 'movie_poster_card.dart';

class MovieGrid extends StatelessWidget {
  final ScrollController scrollController;

  const MovieGrid({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesViewModel>(
      builder: (context, moviesViewModel, child) {
        final movies = moviesViewModel.searchQuery.isNotEmpty
            ? moviesViewModel.searchResults
            : moviesViewModel.popularMovies;

        if (moviesViewModel.isLoading && movies.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando películas...'),
              ],
            ),
          );
        }

        if (movies.isEmpty && !moviesViewModel.isLoading) {
          return _buildEmptyState(moviesViewModel);
        }

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: movies.length + (moviesViewModel.isLoading ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= movies.length) {
              return _buildLoadingCard();
            }

            return MoviePosterCard(movie: movies[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(MoviesViewModel moviesViewModel) {
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

  Widget _buildLoadingCard() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}