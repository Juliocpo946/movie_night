import '../repositories/movie_repository.dart';

class DeleteRating {
  final MovieRepository repository;

  DeleteRating(this.repository);

  Future<void> call(String sessionId, int movieId) async {
    await repository.deleteRating(sessionId, movieId);
  }
}