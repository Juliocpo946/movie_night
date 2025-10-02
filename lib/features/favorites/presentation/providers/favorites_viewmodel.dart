import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/user.dart';
import '../../data/datasources/favorites_remote_datasource.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/entities/favorite_movie.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/mark_as_favorite_usecase.dart';

class FavoritesViewModel extends ChangeNotifier {
  late final MarkAsFavoriteUseCase _markAsFavorite;
  late final GetFavoritesUseCase _getFavorites;

  User? _currentUser;
  String? _sessionId;
  List<FavoriteMovie> _favoriteMovies = [];
  Failure? _failure;

  FavoritesViewModel() {
    final remoteDatasource = FavoritesRemoteDatasource();
    final repository = FavoritesRepositoryImpl(remoteDatasource);
    _markAsFavorite = MarkAsFavoriteUseCase(repository);
    _getFavorites = GetFavoritesUseCase(repository);
  }

  List<FavoriteMovie> get favoriteMovies => _favoriteMovies;
  Failure? get failure => _failure;

  void updateCredentials({User? user, String? sessionId}) {
    bool needsUpdate = false;
    if (user != null && _currentUser != user) {
      _currentUser = user;
      needsUpdate = true;
    }
    if (sessionId != null && _sessionId != sessionId) {
      _sessionId = sessionId;
      needsUpdate = true;
    }

    if (needsUpdate) {
      fetchFavorites();
    }
  }

  void clearFavorites() {
    _favoriteMovies = [];
    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return _favoriteMovies.any((fav) => fav.id == movieId);
  }

  Future<void> toggleFavoriteStatus(int movieId, String title, String posterPath) async {
    if (_sessionId == null || _currentUser?.id == null) return;

    final isCurrentlyFavorite = isFavorite(movieId);
    final originalFavorites = List<FavoriteMovie>.from(_favoriteMovies);

    if (isCurrentlyFavorite) {
      _favoriteMovies.removeWhere((fav) => fav.id == movieId);
    } else {
      _favoriteMovies.add(FavoriteMovie(id: movieId, title: title, posterPath: posterPath));
    }
    notifyListeners();

    try {
      await _markAsFavorite(
          _sessionId!, _currentUser!.id, movieId, !isCurrentlyFavorite);
    } catch (e) {
      _favoriteMovies = originalFavorites;
      _failure = ServerFailure(message: e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchFavorites() async {
    if (_sessionId == null || _currentUser?.id == null) return;
    try {
      final favorites = await _getFavorites(_sessionId!, _currentUser!.id);
      _favoriteMovies = favorites;
      _failure = null;
    } catch (e) {
      _failure = ServerFailure(message: e.toString());
    } finally {
      notifyListeners();
    }
  }
}