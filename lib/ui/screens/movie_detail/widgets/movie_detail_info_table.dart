import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/ui/screens/movie_detail/widgets/movie_detail_info_row.dart';
import 'package:flutter/material.dart';

class MovieDetailInfoTable extends StatelessWidget {
  final Movie movie;
  const MovieDetailInfoTable({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          MovieDetailInfoRow('Release Date', movie.releaseDate ?? 'N/A'),
          MovieDetailInfoRow('Language',
              movie.originalLanguage?.toUpperCase() ?? 'N/A'),
          MovieDetailInfoRow('Rating',
              '${movie.voteAverage.toStringAsFixed(1)} / 10'),
          MovieDetailInfoRow('Votes', movie.voteCount.toString()),
          MovieDetailInfoRow('Popularity',
              movie.popularity.toStringAsFixed(1)),
          MovieDetailInfoRow('Adult Content', movie.adult ? 'Yes' : 'No'),
        ],
      ),
    );
  }
}