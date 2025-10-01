import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/remote/movie_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDatasource _remoteDatasource;

  MovieRepositoryImpl(this._remoteDatasource);

  @override
  Future<void> markAsFavorite(int accountId, String sessionId, int movieId, bool isFavorite) async {
    await _remoteDatasource.markAsFavorite(accountId, sessionId, movieId, isFavorite);
  }

  @override
  Future<List<Movie>> getFavorites(int accountId, String sessionId) async { // Agrega async
    final movieModels = await _remoteDatasource.getFavoriteMovies(accountId, sessionId); // Agrega await
    return movieModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async { // Agrega async
    try {
      final movieModels = await _remoteDatasource.getPopularMovies(page: page); // Agrega await
      return movieModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener películas populares: ${e.toString()}');
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async { // Agrega async
    try {
      final movieModels = await _remoteDatasource.searchMovies(query, page: page); // Agrega await
      return movieModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al buscar películas: ${e.toString()}');
    }
  }

  @override
  Future<void> addRating(String sessionId, int movieId, double rating) async {
    await _remoteDatasource.addRating(sessionId, movieId, rating);
  }

  @override
  Future<void> deleteRating(String sessionId, int movieId) async {
    await _remoteDatasource.deleteRating(sessionId, movieId);
  }
}