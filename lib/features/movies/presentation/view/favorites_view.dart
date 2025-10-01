import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/movies_viewmodel.dart';
import '../widgets/movie_poster_card.dart';
import '../../../../core/config/theme.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Películas Favoritas'),
      ),
      body: Consumer<MoviesViewModel>(
        builder: (context, moviesViewModel, child) {
          if (moviesViewModel.favoriteMovies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: AppTheme.lightGray,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aún no has añadido películas a tus favoritos',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.lightGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: moviesViewModel.favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = moviesViewModel.favoriteMovies[index];
              return MoviePosterCard(movie: movie);
            },
          );
        },
      ),
    );
  }
}