import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_detail.dart';

class MovieService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = '8a746533888ce6d40f350767323ce096';  // Updated API key

  Future<List<Movie>> getMovies(String category) async {
    final endpoint = _getEndpoint(category);
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$endpoint?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Response: ${response.body}'); // Add this for debugging
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      print('API Error: ${response.statusCode} - ${response.body}'); // Add this for debugging
      throw Exception('Failed to load movies');
    }
  }

  String _getEndpoint(String category) {
    switch (category.toLowerCase()) {
      case 'popular':
        return 'popular';
      case 'top rated':
        return 'top_rated';
      case 'now playing':
        return 'now_playing';
      case 'upcoming':
        return 'upcoming';
      default:
        return 'popular';
    }
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/movie/$movieId?api_key=$_apiKey&append_to_response=videos,credits,reviews,recommendations',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetail.fromJson(data);
    } else {
      throw Exception('Failed to load movie detail');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}