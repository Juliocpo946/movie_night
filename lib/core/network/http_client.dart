import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late http.Client _client;

  HttpClient._internal() {
    _client = http.Client();
  }

  factory HttpClient() => _instance;

  http.Client get client => _client;

  void close() {
    _client.close();
  }
}