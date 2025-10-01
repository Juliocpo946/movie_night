import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';

class AuthRemoteDatasource {
  final http.Client _client;
  final String _baseUrl;
  final String _apiKey;

  AuthRemoteDatasource({http.Client? client})
      : _client = client ?? http.Client(),
        _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3',
        _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  Future<String> createRequestToken() async {
    final url = Uri.parse('$_baseUrl/authentication/token/new').replace(queryParameters: {'api_key': _apiKey});
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['request_token'] as String;
    } else {
      throw Exception('Error al crear el token de solicitud');
    }
  }

  Future<String> validateTokenWithLogin(String username, String password, String requestToken) async {
    final url = Uri.parse('$_baseUrl/authentication/token/validate_with_login').replace(queryParameters: {'api_key': _apiKey});
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'request_token': requestToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['request_token'] as String;
    } else {
      throw Exception('Nombre de usuario o contraseña inválidos');
    }
  }

  Future<String> createSession(String validatedRequestToken) async {
    final url = Uri.parse('$_baseUrl/authentication/session/new').replace(queryParameters: {'api_key': _apiKey});
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'request_token': validatedRequestToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['session_id'] as String;
    } else {
      throw Exception('Error al crear la sesión');
    }
  }

  Future<User> getAccountDetails(String sessionId) async {
    final url = Uri.parse('$_baseUrl/account').replace(queryParameters: {
      'api_key': _apiKey,
      'session_id': sessionId,
    });
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User(
        id: data['id'],
        name: data['username'] ?? data['name'],
        email: 'No disponible',
      );
    } else {
      throw Exception('Error al obtener los detalles de la cuenta');
    }
  }
}