import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/user.dart';
import '../models/auth_response_model.dart';

class AuthRemoteDatasource {
  final http.Client _client;
  final String _baseUrl;

  AuthRemoteDatasource()
      : _client = HttpClient().client,
        _baseUrl = AppConstants.tmdbBaseUrl;

  Future<AuthResponseModel> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/users/login');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(json.decode(response.body));
    } else {
      final errorData = json.decode(response.body);
      throw ServerException(message: errorData['detail'] ?? 'Error de autenticación.');
    }
  }

  Future<User> register(
      String username, String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/register');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User(
        id: data['id'],
        name: data['username'],
        email: data['email'],
      );
    } else {
      final errorData = json.decode(response.body);
      throw ServerException(message: errorData['detail'] ?? 'Error al registrar el usuario.');
    }
  }

  Future<User> getAccountDetails(String userId) async {
    // Este método ya no es necesario con la nueva API, pero lo mantenemos por si se añade en el futuro.
    // De momento, devuelve un usuario genérico.
    return User(id: int.parse(userId), name: 'User', email: '');
  }
}