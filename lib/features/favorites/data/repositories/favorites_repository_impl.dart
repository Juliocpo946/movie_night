import '../../../../shared/domain/entities/movie.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';
import '../../../movies/data/models/movie_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDatasource remoteDatasource;

  FavoritesRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> markAsFavorite(int accountId, String sessionId, int movieId, bool isFavorite) async {
    await remoteDatasource.markAsFavorite(accountId, sessionId, movieId, isFavorite);
  }

  @override
  Future<List<Movie>> getFavorites(int accountId, String sessionId) async {
    final movieModels = await remoteDatasource.getFavoriteMovies(accountId, sessionId);
    return movieModels.map((model) => model.toEntity()).toList();
  }
}