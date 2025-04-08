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
  final String backdropPath;

  @HiveField(5)
  final String releaseDate;

  @HiveField(6)
  final double voteAverage;

  @HiveField(7)
  final double? rating;  // Add this field

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    this.rating,  // Add this parameter
  });

  // Update fromJson to include rating
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] ?? '', // Make sure it's not null
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      rating: json['rating']?.toDouble(),  // Add this field
    );
  }

  // Update fromMap for database operations
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title'] as String,
      overview: map['overview'] as String,
      posterPath: map['posterPath'] as String,
      backdropPath: map['backdropPath'] as String,
      releaseDate: map['releaseDate'] as String,
      voteAverage: map['voteAverage'] as double,
      rating: map['rating']?.toDouble(),  // Add this field
    );
  }

  // Add toMap method for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'releaseDate': releaseDate,
      'voteAverage': voteAverage,
      'rating': rating,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
    };
  }
}