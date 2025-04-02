import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  final MovieService _movieService = MovieService();
  List<Movie> _movies = [];
  List<Movie> _favorites = [];
  bool _isLoading = false;
  List<Movie> _searchResults = [];
  String _searchQuery = '';

  List<Movie> get movies => _movies;
  List<Movie> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _movies = await _movieService.getPopularMovies();
    } catch (e) {
      _movies = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final box = await Hive.openBox<Movie>('favorites');
    _favorites = box.values.toList();
    notifyListeners();
  }

  Future<void> addToFavorites(Movie movie) async {
    final box = await Hive.openBox<Movie>('favorites');
    await box.put(movie.id.toString(), movie);
    _favorites = box.values.toList();
    notifyListeners();
  }

  Future<void> removeFromFavorites(Movie movie) async {
    final box = await Hive.openBox<Movie>('favorites');
    await box.delete(movie.id.toString());
    _favorites = box.values.toList();
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favorites.any((element) => element.id == movie.id);
  }

  List<Movie> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _searchQuery = '';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _searchQuery = query;
    notifyListeners();

    try {
      _searchResults = await _movieService.searchMovies(query);
    } catch (e) {
      _searchResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}