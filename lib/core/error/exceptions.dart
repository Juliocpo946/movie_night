class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class CacheException implements Exception {}

class InvalidInputException implements Exception {
  final String message;

  InvalidInputException({required this.message});
}