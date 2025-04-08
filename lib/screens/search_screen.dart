import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              context.read<MovieProvider>().searchMovies(query);
              setState(() => _hasSearched = true);
            }
          },
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_hasSearched) {
            return const Center(
              child: Text('Search for movies...'),
            );
          }

          if (provider.searchResults.isEmpty) {
            return const Center(
              child: Text('No movies found'),
            );
          }

          return MovieGrid(movies: provider.searchResults);
        },
      ),
    );
  }
}