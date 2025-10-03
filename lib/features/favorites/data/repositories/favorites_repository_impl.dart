import '../../../movies/domain/entities/movie.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDatasource remoteDatasource;

  FavoritesRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> markAsFavorite(String token, int userId, int movieId, bool isFavorite) async {
    await remoteDatasource.markAsFavorite(token, userId, movieId, isFavorite);
  }

  @override
  Future<List<Movie>> getFavorites(String token, int userId) async {
    final movieModels = await remoteDatasource.getFavoriteMovies(token, userId);
    return movieModels.map((model) => model.toEntity()).toList();
  }
}