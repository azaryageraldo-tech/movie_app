import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class WatchLaterScreen extends StatelessWidget {
  const WatchLaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch Later'),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          final watchLaterMovies = provider.watchLater;

          if (watchLaterMovies.isEmpty) {
            return const Center(
              child: Text('No movies in watch later list'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: watchLaterMovies.length,
            itemBuilder: (context, index) {
              final movie = watchLaterMovies[index];
              return MovieCard(movie: movie);
            },
          );
        },
      ),
    );
  }
}