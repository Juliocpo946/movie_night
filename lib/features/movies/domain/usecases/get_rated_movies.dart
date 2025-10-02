import '../../../../shared/domain/entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetRatedMovies {
  final MovieRepository repository;

  GetRatedMovies(this.repository);

  Future<List<Movie>> call(String sessionId, int accountId) async {
    return await repository.getRatedMovies(sessionId, accountId);
  }
}