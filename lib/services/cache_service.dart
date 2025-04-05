import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../models/movie.dart';

class CacheService {
  static const String movieListKey = 'movie_list';
  final _cacheManager = DefaultCacheManager();

  Future<void> cacheMovies(List<Movie> movies, String category) async {
    final moviesJson = jsonEncode(movies.map((m) => m.toJson()).toList());
    await _cacheManager.putFile(
      '${movieListKey}_$category',
      Uint8List.fromList(utf8.encode(moviesJson)),
    );
  }

  Future<List<Movie>> getCachedMovies(String category) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache('${movieListKey}_$category');
      if (fileInfo == null) return [];

      final jsonString = await fileInfo.file.readAsString();
      final List<dynamic> moviesJson = jsonDecode(jsonString);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}