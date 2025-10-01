import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/movie_model.dart';

class MovieRemoteDatasource {
  final http.Client _client;
  final String _baseUrl;
  final String _apiKey;

  MovieRemoteDatasource({
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3',
        _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  Future<void> markAsFavorite(int accountId, String sessionId, int movieId, bool isFavorite) async {
    final url = Uri.parse('$_baseUrl/account/$accountId/favorite').replace(queryParameters: {
      'api_key': _apiKey,
      'session_id': sessionId,
    });

    final response = await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json;charset=utf-8',
      },
      body: json.encode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': isFavorite,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al marcar como favorito: ${response.body}');
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
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'] as List<dynamic>;

      return results.map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener películas favoritas: ${response.body}');
    }
  }

  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    try {
      final url = Uri.parse('$_baseUrl/movie/popular').replace(queryParameters: {
        'api_key': _apiKey,
        'page': page.toString(),
        'language': 'es-ES',
      });

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] as List<dynamic>;

        return results.map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>)).where((movie) => movie.posterPath.isNotEmpty).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final url = Uri.parse('$_baseUrl/search/movie').replace(queryParameters: {
        'api_key': _apiKey,
        'query': query.trim(),
        'page': page.toString(),
        'language': 'es-ES',
        'include_adult': 'false',
      });

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] as List<dynamic>;

        return results.map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>)).where((movie) => movie.posterPath.isNotEmpty).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de búsqueda: ${e.toString()}');
    }
  }

  // NUEVOS MÉTODOS
  Future<void> addRating(String sessionId, int movieId, double rating) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId/rating').replace(queryParameters: {
      'api_key': _apiKey,
      'session_id': sessionId,
    });

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json;charset=utf-8'},
      body: json.encode({'value': rating}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al añadir la calificación: ${response.body}');
    }
  }

  Future<void> deleteRating(String sessionId, int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId/rating').replace(queryParameters: {
      'api_key': _apiKey,
      'session_id': sessionId,
    });

    final response = await _client.delete(
      url,
      headers: {'Content-Type': 'application/json;charset=utf-8'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la calificación: ${response.body}');
    }
  }

  void dispose() {
    _client.close();
  }
}