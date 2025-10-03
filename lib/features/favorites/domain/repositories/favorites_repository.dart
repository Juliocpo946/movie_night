import '../../../movies/domain/entities/movie.dart';

abstract class FavoritesRepository {
  Future<void> markAsFavorite(String token, int userId, int movieId, bool isFavorite);
  Future<List<Movie>> getFavorites(String token, int userId);
}