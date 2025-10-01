import '../../../../shared/domain/entities/movie.dart';

abstract class FavoritesRepository {
  Future<void> markAsFavorite(int accountId, String sessionId, int movieId, bool isFavorite);
  Future<List<Movie>> getFavorites(int accountId, String sessionId);
}