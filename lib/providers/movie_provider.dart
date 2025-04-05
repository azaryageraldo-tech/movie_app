import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();
  List<Movie> _movies = [];
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String _selectedCategory = 'Popular';
  List<Movie> _favorites = [];
  Map<int, double> _userRatings = {};
  String? _error;

  List<Movie> get movies => _movies;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  List<Movie> get favorites => _favorites;
  String? get error => _error;

  double? getUserRating(int movieId) => _userRatings[movieId];

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _movieService.searchMovies(query);
    } catch (e) {
      _searchResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void rateMovie(Movie movie, double rating) {
    _userRatings[movie.id] = rating;
    notifyListeners();
  }

  Future<void> fetchMovies(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _movies = await _movieService.getMovies(category);
      _selectedCategory = category;
    } catch (e) {
      _error = 'Failed to load movies';
      _movies = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<MovieDetail> fetchMovieDetail(int movieId) async {
    try {
      return await _movieService.getMovieDetail(movieId);
    } catch (e) {
      throw Exception('Failed to load movie detail');
    }
  }

  void addToFavorites(Movie movie) {
    if (!_favorites.contains(movie)) {
      _favorites.add(movie);
      notifyListeners();
    }
  }

  void removeFromFavorites(Movie movie) {
    _favorites.removeWhere((m) => m.id == movie.id);
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favorites.any((m) => m.id == movie.id);
  }
}