import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../providers/theme_provider.dart';

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
          final ratings = provider.getAllUserRatings();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 16),
              const Text(
                'Movie Statistics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatCard('Watch Later', watchLaterCount),
              const SizedBox(height: 8),
              _buildStatCard('Favorites', favoritesCount),
              const SizedBox(height: 16),
              if (ratings.isNotEmpty) ...[
                const Text(
                  'Your Ratings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...ratings.entries.map((entry) => _buildRatingItem(entry.key, entry.value)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, int count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingItem(int movieId, double rating) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Icon(Icons.movie),
            const SizedBox(width: 8),
            Text('Movie ID: $movieId'),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(rating.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}