import '../entities/favorite_movie.dart';

abstract class FavoritesRepository {
  Future<void> markAsFavorite(String token, int userId, int movieId, bool isFavorite);
  Future<List<FavoriteMovie>> getFavorites(String token, int userId);
}