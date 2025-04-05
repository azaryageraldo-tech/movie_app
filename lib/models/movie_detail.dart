class MovieDetail {
  final String? trailerKey;
  final List<Cast> cast;
  final List<Movie> recommendations;
  final List<Review> reviews;

  MovieDetail({
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