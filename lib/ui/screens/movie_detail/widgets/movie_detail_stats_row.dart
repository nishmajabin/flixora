import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/ui/screens/movie_detail/widgets/movie_detail_stat_box.dart';
import 'package:flutter/material.dart';

class MovieDetailStatsRow extends StatelessWidget {
  final Movie movie;
  const MovieDetailStatsRow({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MovieDetailStatBox(label: '⭐ Rating',
            value: movie.voteAverage.toStringAsFixed(1)),
        const SizedBox(width: 8),
        MovieDetailStatBox(label: '🗳️ Votes',
            value: _fmt(movie.voteCount)),
        const SizedBox(width: 8),
        MovieDetailStatBox(label: '🔥 Popularity',
            value: movie.popularity.toStringAsFixed(0)),
      ],
    );
  }

  static String _fmt(int c) {
    if (c >= 1000000) return '${(c / 1000000).toStringAsFixed(1)}M';
    if (c >= 1000) return '${(c / 1000).toStringAsFixed(1)}K';
    return c.toString();
  }
}