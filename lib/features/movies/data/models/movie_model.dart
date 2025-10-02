import '../../../../shared/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.releaseDate,
    required super.voteAverage,
    required super.voteCount,
    required super.genreIds,
    required super.adult,
    required super.originalLanguage,
    required super.originalTitle,
    required super.popularity,
    required super.video,
    required super.rating,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String? ?? '',
      releaseDate: json['release_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      adult: json['adult'] as bool? ?? false,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      video: json['video'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
      'adult': adult,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'popularity': popularity,
      'video': video,
    };
  }

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
      genreIds: genreIds,
      adult: adult,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      popularity: popularity,
      video: video,
      rating: rating,
    );
  }
}