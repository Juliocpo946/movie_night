import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/http_client.dart';
import '../../../../../core/utils/constants.dart';
import '../../models/movie_model.dart';
import '../../models/rated_movie_model.dart';

class MovieRemoteDatasource {
  final http.Client _client;
  final String _baseUrl;

  MovieRemoteDatasource()
      : _client = HttpClient().client,
        _baseUrl = AppConstants.tmdbBaseUrl;

  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    try {
      final url = Uri.parse('$_baseUrl/movies/popular?page=$page');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);

        return results
            .map((movieJson) =>
            MovieModel.fromJson(movieJson as Map<String, dynamic>))
            .where((movie) => movie.posterPath.isNotEmpty)
            .toList();
      } else {
        throw ServerException(
            message: 'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw ServerException(message: 'Error de conexión: ${e.toString()}');
    }
  }

  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final url =
      Uri.parse('$_baseUrl/movies/search').replace(queryParameters: {
        'query': query.trim(),
        'page': page.toString(),
      });

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);

        return results
            .map((movieJson) =>
            MovieModel.fromJson(movieJson as Map<String, dynamic>))
            .where((movie) => movie.posterPath.isNotEmpty)
            .toList();
      } else {
        throw ServerException(
            message: 'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw ServerException(message: 'Error de búsqueda: ${e.toString()}');
    }
  }

  Future<void> addRating(
      String token, int userId, int movieId, double rating) async {
    final url = Uri.parse('$_baseUrl/users/$userId/ratings');

    final response = await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json;charset=utf-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'movie_id': movieId, 'score': rating}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException(
          message: 'Error al añadir la calificación: ${response.body}');
    }
  }

  Future<void> deleteRating(String token, int userId, int movieId) async {
    final url = Uri.parse('$_baseUrl/users/$userId/ratings/$movieId');

    final response = await _client.delete(
      url,
      headers: {
        'Content-Type': 'application/json;charset=utf-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw ServerException(
          message: 'Error al eliminar la calificación: ${response.body}');
    }
  }

  Future<List<RatedMovieModel>> getRatedMovies(
      String token, int userId) async {
    try {
      final url = Uri.parse('$_baseUrl/users/$userId/ratings');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        return results
            .map((ratingJson) =>
            RatedMovieModel.fromJson(ratingJson as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
            message: 'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw ServerException(message: 'Error de conexión: ${e.toString()}');
    }
  }

  void dispose() {
    _client.close();
  }
}