import '../../../../shared/domain/entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository _repository;

  GetPopularMovies(this._repository);

  Future<List<Movie>> call({int page = 1}) async {
    if (page < 1) {
      throw Exception('La página debe ser mayor a 0');
    }

    return await _repository.getPopularMovies(page: page);
  }
}