import '../../../../shared/domain/entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository _repository;

  SearchMovies(this._repository);

  Future<List<Movie>> call(String query, {int page = 1}) async {
    if (query.trim().isEmpty) {
      throw Exception('La búsqueda no puede estar vacía');
    }

    if (page < 1) {
      throw Exception('La página debe ser mayor a 0');
    }

    return await _repository.searchMovies(query.trim(), page: page);
  }
}