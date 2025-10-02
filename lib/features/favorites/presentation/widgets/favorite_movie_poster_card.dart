import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/app_theme.dart';
import '../../domain/entities/favorite_movie.dart';

class FavoriteMoviePosterCard extends StatelessWidget {
  final FavoriteMovie movie;

  const FavoriteMoviePosterCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: _buildPosterImage(),
          ),
          Expanded(
            flex: 1,
            child: _buildMovieInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterImage() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.softCharcoal,
      ),
      child: movie.posterPath.isNotEmpty
          ? CachedNetworkImage(
        imageUrl: movie.fullPosterUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
        const Icon(Icons.movie_creation_outlined),
      )
          : const Center(
        child: Icon(
          Icons.movie_outlined,
          color: AppTheme.lightGray,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildMovieInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        movie.title,
        style: const TextStyle(
          color: AppTheme.pureWhite,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}