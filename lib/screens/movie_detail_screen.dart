import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
    _movieDetailFuture = context.read<MovieProvider>().fetchMovieDetail(widget.movie.id);
  }

  void _launchTrailer(String? trailerKey) async {
    if (trailerKey != null) {
      final url = Uri.parse('https://www.youtube.com/watch?v=$trailerKey');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'movie-${movie.id}',
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          _buildAppBar(context, movieDetail),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverview(),
                  const SizedBox(height: 24),
                  _buildCastList(movieDetail.cast),
                  const SizedBox(height: 24),
                  _buildRecommendations(movieDetail.recommendations),
                  const SizedBox(height: 24),
                  _buildReviews(movieDetail.reviews),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Di dalam class _MovieDetailScreenState
  void _shareMovie() {
    Share.share(
      'Check out ${widget.movie.title}!\n\n'
      '${widget.movie.overview}\n\n'
      'Rating: ${widget.movie.rating}/10',
    );
  }
  
  // Tambahkan tombol share di AppBar
  Widget _buildAppBar(BuildContext context, MovieDetail detail) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'movie-${widget.movie.id}',
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                fit: BoxFit.cover,
              ),
            ),
            if (detail.trailerKey != null)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () => _launchTrailer(detail.trailerKey),
                  child: const Icon(Icons.play_arrow),
                ),
              ),
          ],
        ),
      ),
      actions: [
        Consumer<MovieProvider>(
          builder: (context, provider, child) {
            final isInWatchLater = provider.isInWatchLater(widget.movie);
            return IconButton(
              icon: Icon(
                isInWatchLater ? Icons.bookmark : Icons.bookmark_border,
                color: isInWatchLater ? Colors.yellow : Colors.white,
              ),
              onPressed: () {
                if (isInWatchLater) {
                  provider.removeFromWatchLater(widget.movie);
                } else {
                  provider.addToWatchLater(widget.movie);
                }
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.star_border),
          onPressed: () => _showRatingDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareMovie,
        ),
      ],
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate this movie'),
        content: Consumer<MovieProvider>(
          builder: (context, provider, child) {
            final currentRating = provider.getUserRating(widget.movie.id);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingBar.builder(
                  initialRating: currentRating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    provider.rateMovie(widget.movie, rating);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Your rating: ${currentRating.toStringAsFixed(1)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.movie.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              'TMDB: ${widget.movie.rating.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 16),
            Consumer<MovieProvider>(
              builder: (context, provider, child) {
                final userRating = provider.getUserRating(widget.movie.id);
                if (userRating > 0) {
                  return Row(
                    children: [
                      const Icon(Icons.star_border, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        'Your rating: ${userRating.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        Text(
          'Release Date: ${widget.movie.releaseDate}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(widget.movie.overview),
      ],
    );
  }

  Widget _buildCastList(List<Cast> cast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: actor.profilePath != null
                          ? CachedNetworkImageProvider(
                              'https://image.tmdb.org/t/p/w200${actor.profilePath}',
                            )
                          : null,
                      child: actor.profilePath == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      actor.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      actor.character,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(List<Movie> recommendations) {
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final movie = recommendations[index];
              return SizedBox(
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: MovieCard(movie: movie),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviews(List<Review> reviews) {
    if (reviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: review.avatarPath != null
                              ? CachedNetworkImageProvider(
                                  'https://image.tmdb.org/t/p/w200${review.avatarPath}',
                                )
                              : null,
                          child: review.avatarPath == null
                              ? Text(review.author[0])
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.author,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (review.rating != null)
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 16, color: Colors.amber),
                                    Text(' ${review.rating}'),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(review.content),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}