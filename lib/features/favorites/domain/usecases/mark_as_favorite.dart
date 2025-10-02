import '../repositories/favorites_repository.dart';

class MarkAsFavorite {
  final FavoritesRepository repository;

  MarkAsFavorite(this.repository);

  Future<void> call(String token, int userId, int movieId, bool isFavorite) async {
    await repository.markAsFavorite(token, userId, movieId, isFavorite);
  }
}