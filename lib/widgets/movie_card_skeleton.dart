import 'package:flutter/material.dart';
import 'skeleton_loader.dart';

class MovieCardSkeleton extends StatelessWidget {
  const MovieCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(
            height: 200,
            borderRadius: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader(
                  width: 120,
                  height: 16,
                ),
                const SizedBox(height: 8),
                const SkeletonLoader(
                  width: 80,
                  height: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}