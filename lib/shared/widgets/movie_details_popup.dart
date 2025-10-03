import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_theme.dart';
import '../../features/favorites/presentation/providers/favorites_viewmodel.dart';
import '../../features/movies/domain/entities/movie.dart';
import '../../features/movies/presentation/providers/movies_viewmodel.dart';

class MovieDetailsPopup extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPopup({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.softCharcoal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBackdropImage(context),
              _buildMovieInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackdropImage(BuildContext context) {
    return Hero(
      tag: 'poster-${movie.id}',
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            child: CachedNetworkImage(
              imageUrl: movie.fullBackdropUrl,
              fit: BoxFit.cover,
              height: 200,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: AppTheme.midnightBlue,
                child: const Icon(Icons.movie_creation_outlined, color: AppTheme.lightGray, size: 50),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    color: AppTheme.pureWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Consumer<FavoritesViewModel>(
                builder: (context, viewModel, child) {
                  final isFavorite = viewModel.isFavorite(movie.id);
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: IconButton(
                      key: ValueKey<bool>(isFavorite),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : AppTheme.lightGray,
                        size: 30,
                      ),
                      onPressed: () {
                        viewModel.toggleFavoriteStatus(movie);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRatingInfo(),
              const SizedBox(width: 16),
              _buildYearSection(),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Sinopsis',
            style: TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.overview.isNotEmpty ? movie.overview : 'No disponible.',
            style: const TextStyle(
              color: AppTheme.lightGray,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildUserRatingSection(context),
        ],
      ),
    );
  }

  Widget _buildRatingInfo() {
    return Row(
      children: [
        const Icon(Icons.star, color: AppTheme.vibrantAmber, size: 15),
        const SizedBox(width: 4),
        Text(
          movie.formattedRating,
          style: const TextStyle(
            color: AppTheme.pureWhite,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text('/10', style: TextStyle(color: AppTheme.lightGray, fontSize: 14)),
      ],
    );
  }

  Widget _buildYearSection() {
    if (movie.releaseYear == 0) return const SizedBox.shrink();
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: AppTheme.lightGray, size: 16),
        const SizedBox(width: 4),
        Text(
          movie.releaseYear.toString(),
          style: const TextStyle(
            color: AppTheme.lightGray,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildUserRatingSection(BuildContext context) {
    return Consumer<MoviesViewModel>(
      builder: (context, viewModel, child) {
        final userRating = viewModel.ratedMovies[movie.id];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tu Calificación',
              style: TextStyle(
                color: AppTheme.pureWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    final ratingValue = (index + 1) * 2.0;
                    return IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        userRating != null && userRating >= ratingValue
                            ? Icons.star
                            : Icons.star_border,
                        color: AppTheme.vibrantAmber,
                      ),
                      onPressed: () {
                        viewModel.rateMovie(movie.id, ratingValue);
                      },
                    );
                  }),
                ),
                if (userRating != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      viewModel.deleteMovieRating(movie.id);
                    },
                  )
              ],
            ),
          ],
        );
      },
    );
  }
}