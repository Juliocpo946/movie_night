import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/utils/constants.dart';
import '../models/favorite_movie_model.dart';

class FavoritesRemoteDatasource {
  final http.Client _client;
  final String _baseUrl;

  FavoritesRemoteDatasource()
      : _client = HttpClient().client,
        _baseUrl = AppConstants.tmdbBaseUrl;

  Future<void> markAsFavorite(
      String token, int userId, int movieId, bool isFavorite) async {
    if (isFavorite) {
      final url = Uri.parse('$_baseUrl/users/$userId/favorites');
      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'movie_id': movieId}),
      );

      if (response.statusCode != 201) {
        throw ServerException(
            message: 'Error al marcar como favorito: ${response.body}');
      }
    } else {
      final url = Uri.parse('$_baseUrl/users/$userId/favorites/$movieId');
      final response = await _client.delete(
        url,
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 204) {
        throw ServerException(
            message: 'Error al desmarcar como favorito: ${response.body}');
      }
    }
  }

  Future<List<FavoriteMovieModel>> getFavoriteMovies(String token, int userId) async {
    final url = Uri.parse('$_baseUrl/users/$userId/favorites');

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
          .map((movieJson) =>
          FavoriteMovieModel.fromJson(movieJson as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(
          message: 'Error al obtener películas favoritas: ${response.body}');
    }
  }
}