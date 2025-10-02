import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/utils/constants.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/register_request_model.dart';

class RegisterRemoteDatasource {
  final http.Client _client;
  final String _baseUrl;

  RegisterRemoteDatasource()
      : _client = HttpClient().client,
        _baseUrl = AppConstants.tmdbBaseUrl;

  Future<UserModel> register(RegisterRequestModel request) async {
    final url = Uri.parse('$_baseUrl/users/register');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      final errorData = json.decode(response.body);
      throw ServerException(
          message: errorData['detail'] ?? 'Error al registrar el usuario.');
    }
  }
}