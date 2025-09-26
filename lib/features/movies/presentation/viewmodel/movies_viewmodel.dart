import 'package:flutter/material.dart';

import '../../data/datasources/remote/movie_remote_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/search_movies.dart';

class MoviesViewModel extends ChangeNotifier {
  late final GetPopularMovies _getPopularMovies;
  late final SearchMovies _searchMovies;

  List<Movie> _popularMovies = [];
  List<Movie> _searchResults = [];
  List<Movie> _upcomingMovies = [];
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isLoadingUpcoming = false;
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
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get upcomingMovies => _upcomingMovies;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  bool get isLoadingUpcoming => _isLoadingUpcoming;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get hasMorePages => _hasMorePages;
  int get currentPage => _currentPage;

  // Carga inicial de datos
  void loadInitialData() {
    loadPopularMovies();
  }

  // Métodos públicos
  Future<void> loadPopularMovies({bool loadMore = false}) async {
    if (_isLoading) return;

    if (!loadMore) {
      _currentPage = 1;
      _popularMovies.clear();
      _hasMorePages = true;
    }

    _setLoading(true);
    _clearError();

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
    _clearError();

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
    await Future.wait([
      loadPopularMovies(),
    ]);
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingUpcoming(bool loading) {
    _isLoadingUpcoming = loading;
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

  void _clearError() {
    _errorMessage = null;
  }
}