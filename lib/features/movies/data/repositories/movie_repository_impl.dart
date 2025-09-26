import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/remote/movie_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDatasource _remoteDatasource;

  MovieRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final movieModels = await _remoteDatasource.getPopularMovies(page: page);
      return movieModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener películas populares: ${e.toString()}');
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final movieModels = await _remoteDatasource.searchMovies(query, page: page);
      return movieModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al buscar películas: ${e.toString()}');
    }
  }

}