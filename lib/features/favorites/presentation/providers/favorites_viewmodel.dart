import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/movie.dart';
import '../../../auth/domain/entities/user.dart';
import '../../data/datasources/favorites_remote_datasource.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/mark_as_favorite.dart';

class FavoritesViewModel extends ChangeNotifier {
  late final MarkAsFavorite _markAsFavorite;
  late final GetFavorites _getFavorites;

  User? _currentUser;
  String? _sessionId;
  List<Movie> _favoriteMovies = [];
  Failure? _failure;

  FavoritesViewModel() {
    final remoteDatasource = FavoritesRemoteDatasource();
    final repository = FavoritesRepositoryImpl(remoteDatasource);
    _markAsFavorite = MarkAsFavorite(repository);
    _getFavorites = GetFavorites(repository);
  }

  List<Movie> get favoriteMovies => _favoriteMovies;
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

  bool isFavorite(Movie movie) {
    return _favoriteMovies.any((fav) => fav.id == movie.id);
  }

  Future<void> toggleFavoriteStatus(Movie movie) async {
    if (_sessionId == null || _currentUser?.id == null) return;

    final isCurrentlyFavorite = isFavorite(movie);
    final originalFavorites = List<Movie>.from(_favoriteMovies);

    if (isCurrentlyFavorite) {
      _favoriteMovies.removeWhere((fav) => fav.id == movie.id);
    } else {
      _favoriteMovies.add(movie);
    }
    notifyListeners();

    try {
      await _markAsFavorite(
          _sessionId!, _currentUser!.id!, movie.id, !isCurrentlyFavorite);
    } catch (e) {
      _favoriteMovies = originalFavorites;
      _failure = ServerFailure(message: e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchFavorites() async {
    if (_sessionId == null || _currentUser?.id == null) return;
    try {
      final favorites = await _getFavorites(_sessionId!, _currentUser!.id!);
      _favoriteMovies = favorites;
      _failure = null;
    } catch (e) {
      _failure = ServerFailure(message: e.toString());
    } finally {
      notifyListeners();
    }
  }
}