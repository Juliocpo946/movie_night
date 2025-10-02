import '../repositories/favorites_repository.dart';

class MarkAsFavoriteUseCase {
  final FavoritesRepository repository;

  MarkAsFavoriteUseCase(this.repository);

  Future<void> call(String token, int userId, int movieId, bool isFavorite) async {
    await repository.markAsFavorite(token, userId, movieId, isFavorite);
  }
}