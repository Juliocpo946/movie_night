import '../../../../shared/domain/entities/movie.dart';
import '../entities/rated_movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopularMovies({int page = 1});
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<void> addRating(String token, int userId, int movieId, double rating);
  Future<void> deleteRating(String token, int userId, int movieId);
  Future<List<RatedMovie>> getRatedMovies(String token, int userId);
}