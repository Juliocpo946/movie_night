import '../repositories/favorites_repository.dart';

class MarkAsFavorite {
  final FavoritesRepository repository;

  MarkAsFavorite(this.repository);

  Future<void> call(int accountId, String sessionId, int movieId, bool isFavorite) async {
    await repository.markAsFavorite(accountId, sessionId, movieId, isFavorite);
  }
}