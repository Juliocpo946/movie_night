import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/config/app_theme.dart';
import '../domain/entities/movie.dart';
import 'movie_details_popup.dart';

class MoviePosterCard extends StatefulWidget {
  final Movie movie;

  const MoviePosterCard({
    super.key,
    required this.movie,
  });

  @override
  State<MoviePosterCard> createState() => _MoviePosterCardState();
}

class _MoviePosterCardState extends State<MoviePosterCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MovieDetailsPopup(movie: widget.movie);
            },
          );
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _buildPosterImage(),
              ),
              Expanded(
                flex: 2,
                child: _buildMovieInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    return Hero(
      tag: 'poster-${widget.movie.id}',
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppTheme.softCharcoal,
        ),
        child: widget.movie.posterPath.isNotEmpty
            ? CachedNetworkImage(
          imageUrl: widget.movie.fullPosterUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildImagePlaceholder(),
          errorWidget: (context, url, error) => _buildImageError(),
        )
            : _buildImageError(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.vibrantAmber,
          ),
          SizedBox(height: 8),
          Text(
            'Cargando...',
            style: TextStyle(
              color: AppTheme.lightGray,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            color: AppTheme.lightGray,
            size: 32,
          ),
          SizedBox(height: 4),
          Text(
            'Sin imagen',
            style: TextStyle(
              color: AppTheme.lightGray,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              widget.movie.title,
              style: const TextStyle(
                color: AppTheme.pureWhite,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildRatingSection(),
              const Spacer(),
              _buildYearSection(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star,
          color: AppTheme.vibrantAmber,
          size: 12,
        ),
        const SizedBox(width: 2),
        Text(
          widget.movie.formattedRating,
          style: const TextStyle(
            color: AppTheme.lightGray,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildYearSection() {
    if (widget.movie.releaseYear == 0) return const SizedBox.shrink();

    return Text(
      widget.movie.releaseYear.toString(),
      style: const TextStyle(
        color: AppTheme.lightGray,
        fontSize: 10,
      ),
    );
  }
}