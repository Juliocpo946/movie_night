import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/datasources/remote/movie_remote_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/search_movies.dart';
import '../../domain/usecases/mark_as_favorite.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_rating.dart'; // Importar
import '../../domain/usecases/delete_rating.dart'; // Importar

class MoviesViewModel extends ChangeNotifier {
  late final GetPopularMovies _getPopularMovies;
  late final SearchMovies _searchMovies;
  late final MarkAsFavorite _markAsFavorite;
  late final GetFavorites _getFavorites;
  late final AddRating _addRating; // Añadir
  late final DeleteRating _deleteRating; // Añadir

  User? _currentUser;
  String? _sessionId;
  List<Movie> _popularMovies = [];
  List<Movie> _searchResults = [];
  List<Movie> _favoriteMovies = [];
  final Map<int, double> _ratedMovies = {}; // Estado para calificaciones
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  String _searchQuery = '';
  int _currentPage = 1;
  bool _hasMorePages = true;

  MoviesViewModel() {
    _initializeUseCases();
    loadInitialData();
  }

  void _initializeUseCases() {
    final remoteDatasource = MovieRemoteDatasource();
    final repository = MovieRepositoryImpl(remoteDatasource);
    _getPopularMovies = GetPopularMovies(repository);
    _searchMovies = SearchMovies(repository);
    _markAsFavorite = MarkAsFavorite(repository);
    _getFavorites = GetFavorites(repository);
    _addRating = AddRating(repository); // Inicializar
    _deleteRating = DeleteRating(repository); // Inicializar
  }

  User? get currentUser => _currentUser;
  String? get sessionId => _sessionId;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get favoriteMovies => _favoriteMovies;
  Map<int, double> get ratedMovies => _ratedMovies;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get hasMorePages => _hasMorePages;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setSessionId(String sessionId) {
    _sessionId = sessionId;
    fetchFavorites();
  }

  void logout(BuildContext context) {
    _currentUser = null;
    _sessionId = null;
    _popularMovies.clear();
    _searchResults.clear();
    _favoriteMovies.clear();
    _ratedMovies.clear();
    _searchQuery = '';
    notifyListeners();
    context.go('/login');
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
        _currentUser!.id!,
        _sessionId!,
        movie.id,
        !isCurrentlyFavorite,
      );
    } catch (e) {
      _favoriteMovies = originalFavorites;
      _setError(e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchFavorites() async {
    if (_sessionId == null || _currentUser?.id == null) return;
    try {
      final favorites = await _getFavorites(_currentUser!.id!, _sessionId!);
      _favoriteMovies = favorites;
    } catch (e) {
      _setError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  // NUEVOS MÉTODOS PARA CALIFICACIÓN
  Future<void> rateMovie(int movieId, double rating) async {
    if (_sessionId == null) return;
    _ratedMovies[movieId] = rating;
    notifyListeners();
    try {
      await _addRating(_sessionId!, movieId, rating);
    } catch (e) {
      _ratedMovies.remove(movieId);
      _setError(e.toString());
      notifyListeners();
    }
  }

  Future<void> deleteMovieRating(int movieId) async {
    if (_sessionId == null) return;
    final originalRating = _ratedMovies[movieId];
    _ratedMovies.remove(movieId);
    notifyListeners();
    try {
      await _deleteRating(_sessionId!, movieId);
    } catch (e) {
      if (originalRating != null) {
        _ratedMovies[movieId] = originalRating;
      }
      _setError(e.toString());
      notifyListeners();
    }
  }

  void loadInitialData() {
    loadPopularMovies();
  }

  Future<void> loadPopularMovies({bool loadMore = false}) async {
    if (_isLoading) return;
    if (!loadMore) {
      _currentPage = 1;
      _popularMovies.clear();
      _hasMorePages = true;
    }
    _setLoading(true);
    clearError();

    try {
      final movies = await _getPopularMovies.call(page: _currentPage);
      if (loadMore) {
        _popularMovies.addAll(movies);
      } else {
        _popularMovies = movies;
      }
      _hasMorePages = movies.isNotEmpty && movies.length >= 20;
      if (_hasMorePages) _currentPage++;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.trim() == _searchQuery.trim()) return;
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }
    _setSearching(true);
    clearError();

    try {
      final results = await _searchMovies.call(_searchQuery);
      _searchResults = results;
    } catch (e) {
      _setError(e.toString());
      _searchResults.clear();
    } finally {
      _setSearching(false);
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadPopularMovies();
    await fetchFavorites();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSearching(bool searching) {
    _isSearching = searching;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
}