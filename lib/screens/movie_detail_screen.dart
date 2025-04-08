import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart'; // Add this import
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../providers/movie_provider.dart';
import '../widgets/cast_list.dart';
import '../widgets/review_list.dart';
import '../widgets/movie_recommendations.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetail> _movieDetailFuture;

  @override
  void initState() {
    super.initState();
    _movieDetailFuture = Provider.of<MovieProvider>(context, listen: false)
        .fetchMovieDetail(widget.movie.id);
  }

  void _playTrailer(String? trailerKey) async {
    if (trailerKey == null) return;
    final url = Uri.parse('https://www.youtube.com/watch?v=$trailerKey');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieDetail>(
        future: _movieDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final movieDetail = snapshot.data!;
          return CustomScrollView(
            slivers: [
              _buildAppBar(movieDetail),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieDetail.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      _buildGenreChips(movieDetail.genres),
                      const SizedBox(height: 16),
                      Text(movieDetail.overview),
                      const SizedBox(height: 16),
                      if (movieDetail.trailerKey != null)
                        ElevatedButton.icon(
                          onPressed: () => _playTrailer(movieDetail.trailerKey),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Watch Trailer'),
                        ),
                      const SizedBox(height: 24),
                      Text(
                        'Cast',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      CastList(cast: movieDetail.cast),
                      const SizedBox(height: 24),
                      Text(
                        'Reviews',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ReviewList(reviews: movieDetail.reviews),
                      const SizedBox(height: 24),
                      Text(
                        'Recommendations',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      MovieRecommendations(movies: movieDetail.recommendations),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(MovieDetail movieDetail) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: movieDetail.backdropPath.isNotEmpty
              ? 'https://image.tmdb.org/t/p/w500${movieDetail.backdropPath}'
              : 'https://via.placeholder.com/500x281',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Provider.of<MovieProvider>(context).isFavorite(widget.movie)
                ? Icons.favorite
                : Icons.favorite_border,
          ),
          onPressed: () {
            final provider = Provider.of<MovieProvider>(context, listen: false);
            if (provider.isFavorite(widget.movie)) {
              provider.removeFromFavorites(widget.movie);
            } else {
              provider.addToFavorites(widget.movie);
            }
          },
        ),
      ],
    );
  }

  Widget _buildGenreChips(List<String> genres) {
    return Wrap(
      spacing: 8,
      children: genres
          .map((genre) => Chip(
                label: Text(genre),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ))
          .toList(),
    );
  }
}