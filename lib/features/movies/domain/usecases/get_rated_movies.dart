import '../entities/rated_movie.dart';
import '../repositories/movie_repository.dart';

class GetRatedMovies {
  final MovieRepository repository;

  GetRatedMovies(this.repository);

  Future<List<RatedMovie>> call(String token, int userId) async {
    return await repository.getRatedMovies(token, userId);
  }
}