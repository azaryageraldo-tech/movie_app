import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = 'YOUR_API_KEY'; // Ganti dengan API key Anda

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query&language=en-US&page=1'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=videos,credits,recommendations,reviews'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    return _getMovies('movie/top_rated');
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    return _getMovies('movie/now_playing');
  }

  Future<List<Movie>> getUpcomingMovies() async {
    return _getMovies('movie/upcoming');
  }

  Future<List<Movie>> _getMovies(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> getMovies(String category, {int page = 1}) async {
    final endpoint = switch (category) {
      'Popular' => 'movie/popular',
      'Top Rated' => 'movie/top_rated',
      'Now Playing' => 'movie/now_playing',
      'Upcoming' => 'movie/upcoming',
      _ => 'movie/popular'
    };

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint?api_key=$apiKey&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits,reviews,recommendations'),
    );
  
    if (response.statusCode == 200) {
      return MovieDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie detail');
    }
  }
}