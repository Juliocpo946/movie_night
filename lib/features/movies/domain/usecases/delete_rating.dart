import '../repositories/movie_repository.dart';

class DeleteRating {
  final MovieRepository repository;

  DeleteRating(this.repository);

  Future<void> call(String token, int userId, int movieId) async {
    await repository.deleteRating(token, userId, movieId);
  }
}