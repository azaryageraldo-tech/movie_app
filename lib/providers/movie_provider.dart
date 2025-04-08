import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();
  final Box<Movie> _favoritesBox = Hive.box<Movie>('favorites');
  
  List<Movie> _movies = [];
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String _selectedCategory = 'Popular';
  String? _error;

  List<Movie> get movies => _movies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get favorites => _favoritesBox.values.toList();
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String? get error => _error;

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

  Future<void> searchMovies(String query) async {
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

  Future<MovieDetail> fetchMovieDetail(int movieId) async {
    try {
      return await _movieService.getMovieDetail(movieId);
    } catch (e) {
      throw Exception('Failed to load movie detail');
    }
  }

  void addToFavorites(Movie movie) {
    if (!isFavorite(movie)) {
      _favoritesBox.put(movie.id.toString(), movie);
      notifyListeners();
    }
  }

  void removeFromFavorites(Movie movie) {
    _favoritesBox.delete(movie.id.toString());
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favoritesBox.containsKey(movie.id.toString());
  }

  List<Movie> _watchLater = [];
  List<Movie> get watchLater => _watchLater;

  final Map<int, double> _userRatings = {};

  void addToWatchLater(Movie movie) {
    if (!isInWatchLater(movie)) {
      _watchLater.add(movie);
      notifyListeners();
    }
  }

  void removeFromWatchLater(Movie movie) {
    _watchLater.removeWhere((m) => m.id == movie.id);
    notifyListeners();
  }

  bool isInWatchLater(Movie movie) {
    return _watchLater.any((m) => m.id == movie.id);
  }

  void rateMovie(int movieId, double rating) {
    _userRatings[movieId] = rating;
    notifyListeners();
  }

  Map<int, double> getAllUserRatings() {
    return Map.from(_userRatings);
  }
}