import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String overview;
  @HiveField(3)
  final String posterPath;
  @HiveField(4)
  final double rating;
  @HiveField(5)
  final String releaseDate;
  @HiveField(6)
  final List<String> genres;
  @HiveField(7)
  final String? trailerUrl;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
    this.genres = const [],
    this.trailerUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genres: (json['genre_ids'] as List<dynamic>?)
          ?.map((id) => _getGenreName(id))
          .toList() ?? [],
      trailerUrl: null, // Will be updated when fetching movie details
    );
  }

  static String _getGenreName(int id) {
    final genreMap = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Science Fiction',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };
    return genreMap[id] ?? 'Unknown';
  }
}