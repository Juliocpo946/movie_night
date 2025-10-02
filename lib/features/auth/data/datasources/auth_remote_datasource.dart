import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/utils/constants.dart';
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
}