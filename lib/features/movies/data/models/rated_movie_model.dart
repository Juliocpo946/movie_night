import '../../domain/entities/rated_movie.dart';

class RatedMovieModel extends RatedMovie {
  const RatedMovieModel({required super.movieId, required super.rating});

  factory RatedMovieModel.fromJson(Map<String, dynamic> json) {
    return RatedMovieModel(
      movieId: json['movie_id'] as int,
      rating: (json['score'] as num).toDouble(),
    );
  }
}