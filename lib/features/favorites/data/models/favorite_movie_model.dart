import '../../domain/entities/favorite_movie.dart';

class FavoriteMovieModel extends FavoriteMovie {
  const FavoriteMovieModel({
    required super.id,
    required super.title,
    required super.posterPath,
  });

  factory FavoriteMovieModel.fromJson(Map<String, dynamic> json) {
    return FavoriteMovieModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      posterPath: json['poster_path'] as String? ?? '',
    );
  }

  FavoriteMovie toEntity() {
    return FavoriteMovie(
      id: id,
      title: title,
      posterPath: posterPath,
    );
  }
}