import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/app_theme.dart';
import '../providers/favorites_viewmodel.dart';
import '../widgets/favorite_movie_poster_card.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Películas Favoritas'),
      ),
      body: Consumer<FavoritesViewModel>(
        builder: (context, favoritesViewModel, child) {
          if (favoritesViewModel.favoriteMovies.isEmpty) {
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
            itemCount: favoritesViewModel.favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoritesViewModel.favoriteMovies[index];
              return FavoriteMoviePosterCard(movie: movie);
            },
          );
        },
      ),
    );
  }
}