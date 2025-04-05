import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: themeProvider.toggleTheme,
              );
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          final watchLaterCount = provider.watchLater.length;
          final favoritesCount = provider.favorites.length;
          final ratedMovies = provider.getAllUserRatings();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatCard(
                context,
                'Movies to Watch',
                watchLaterCount.toString(),
                Icons.bookmark,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                context,
                'Favorite Movies',
                favoritesCount.toString(),
                Icons.favorite,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                context,
                'Rated Movies',
                ratedMovies.length.toString(),
                Icons.star,
              ),
              if (ratedMovies.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Your Ratings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...ratedMovies.map((entry) => _buildRatingItem(context, entry)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(value, style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingItem(BuildContext context, MapEntry<int, double> entry) {
    return ListTile(
      leading: const Icon(Icons.movie),
      title: Text(entry.value.toStringAsFixed(1)),
      trailing: const Icon(Icons.star, color: Colors.amber),
    );
  }
}