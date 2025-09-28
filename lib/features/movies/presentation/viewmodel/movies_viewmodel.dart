import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/datasources/remote/movie_remote_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/search_movies.dart';

class MoviesViewModel extends ChangeNotifier {
  late final GetPopularMovies _getPopularMovies;
  late final SearchMovies _searchMovies;

  User? _currentUser;
  List<Movie> _popularMovies = [];
  List<Movie> _searchResults = [];
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
  }

  // Getters
  User? get currentUser => _currentUser;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get hasMorePages => _hasMorePages;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout(BuildContext context) {
    _currentUser = null;
    _popularMovies.clear();
    _searchResults.clear();
    _searchQuery = '';
    notifyListeners();
    context.go('/login');
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