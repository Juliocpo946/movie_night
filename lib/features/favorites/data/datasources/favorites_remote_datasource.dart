import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/utils/constants.dart';
import '../../../movies/data/models/movie_model.dart';

class FavoritesRemoteDatasource {
  final http.Client _client;
  final String _baseUrl;
  final String _apiKey;

  FavoritesRemoteDatasource()
      : _client = HttpClient().client,
        _baseUrl = AppConstants.tmdbBaseUrl,
        _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  Future<void> markAsFavorite(int accountId, String sessionId, int movieId, bool isFavorite) async {
    final url = Uri.parse('$_baseUrl/account/$accountId/favorite').replace(queryParameters: {
      'api_key': _apiKey,
      'session_id': sessionId,
    });

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json;charset=utf-8'},
      body: json.encode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': isFavorite,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException(message: 'Error al marcar como favorito: ${response.body}');
    }
  }

  Future<List<MovieModel>> getFavoriteMovies(int accountId, String sessionId) async {
    final url = Uri.parse('$_baseUrl/account/$accountId/favorite/movies').replace(queryParameters: {
      'api_key': _apiKey,
      'session_id': sessionId,
      'language': 'es-ES',
      'sort_by': 'created_at.asc',
    });

    final response = await _client.get(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'] as List<dynamic>;
      return results.map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>)).toList();
    } else {
      throw ServerException(message: 'Error al obtener películas favoritas: ${response.body}');
    }
  }
}