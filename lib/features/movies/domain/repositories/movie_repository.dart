import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopularMovies({int page = 1});
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<void> markAsFavorite(int accountId, String sessionId, int movieId, bool isFavorite);
  Future<List<Movie>> getFavorites(int accountId, String sessionId);
}