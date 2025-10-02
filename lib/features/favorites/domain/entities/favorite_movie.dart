import '../../../../core/utils/constants.dart';

class FavoriteMovie {
  final int id;
  final String title;
  final String posterPath;

  const FavoriteMovie({
    required this.id,
    required this.title,
    required this.posterPath,
  });

  String get fullPosterUrl => '${AppConstants.imageBaseUrl}w500$posterPath';
}