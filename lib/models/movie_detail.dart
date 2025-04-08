import '../models/movie.dart';

class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final int runtime;
  final String? trailerKey;
  final List<Cast> cast;
  final List<Movie> recommendations;
  final List<Review> reviews;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    required this.runtime,
    this.trailerKey,
    required this.cast,
    required this.recommendations,
    required this.reviews,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    String? trailerKey;
    if (json['videos']?['results'] != null) {
      final videos = json['videos']['results'] as List;
      final trailer = videos.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );
      trailerKey = trailer?['key'];
    }

    return MovieDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String? ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] as String? ?? '',
      genres: (json['genres'] as List).map((genre) => genre['name'] as String).toList(),
      runtime: json['runtime'] as int? ?? 0,
      trailerKey: trailerKey,
      cast: (json['credits']?['cast'] as List?)
          ?.map((x) => Cast.fromJson(x))
          .take(10)
          .toList() ?? [],
      recommendations: (json['recommendations']?['results'] as List?)
          ?.map((x) => Movie.fromJson(x))
          .take(10)
          .toList() ?? [],
      reviews: (json['reviews']?['results'] as List?)
          ?.map((x) => Review.fromJson(x))
          .take(5)
          .toList() ?? [],
    );
  }
}

class Cast {
  final int id;
  final String name;
  final String? profilePath;
  final String character;

  Cast({
    required this.id,
    required this.name,
    this.profilePath,
    required this.character,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
      character: json['character'],
    );
  }
}

class Review {
  final String id;
  final String author;
  final String content;
  final String? avatarPath;
  final double? rating;

  Review({
    required this.id,
    required this.author,
    required this.content,
    this.avatarPath,
    this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      avatarPath: json['author_details']?['avatar_path'],
      rating: json['author_details']?['rating']?.toDouble(),
    );
  }
}