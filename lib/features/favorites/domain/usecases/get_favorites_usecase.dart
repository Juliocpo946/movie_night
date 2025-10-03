import '../../../movies/domain/entities/movie.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<Movie>> call(String token, int userId) async {
    return await repository.getFavorites(token, userId);
  }
}