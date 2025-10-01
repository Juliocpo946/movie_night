import '../../../../shared/domain/entities/movie.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<List<Movie>> call(int accountId, String sessionId) async {
    return await repository.getFavorites(accountId, sessionId);
  }
}