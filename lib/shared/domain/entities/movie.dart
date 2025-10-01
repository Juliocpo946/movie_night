import '../../../core/utils/constants.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final bool video;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
  });

  String get fullPosterUrl => '${AppConstants.imageBaseUrl}w500$posterPath';
  String get fullBackdropUrl => '${AppConstants.imageBaseUrl}w1280$backdropPath';

  String get formattedRating => voteAverage.toStringAsFixed(1);

  int get releaseYear {
    if (releaseDate.isEmpty) return 0;
    return DateTime.tryParse(releaseDate)?.year ?? 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Movie && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Movie{id: $id, title: $title}';
  }
}