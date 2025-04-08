import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_detail.dart';

class CastList extends StatelessWidget {
  final List<Cast> cast;

  const CastList({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final actor = cast[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
                SizedBox(
                  width: 90,
                  child: Text(
                    actor.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    actor.character,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}