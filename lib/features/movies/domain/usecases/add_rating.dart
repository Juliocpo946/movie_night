import '../repositories/movie_repository.dart';

class AddRating {
  final MovieRepository repository;

  AddRating(this.repository);

  Future<void> call(String token, int userId, int movieId, double rating) async {
    if (rating < 0.5 || rating > 10.0) {
      throw Exception('La calificación debe estar entre 0.5 y 10.0');
    }
    await repository.addRating(token, userId, movieId, rating);
  }
}