import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final String tmdbBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';
}