import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/logic/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailActionButtons extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;

  const MovieDetailActionButtons({required this.movie, required this.isFavorite, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Play button
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 24),
                SizedBox(width: 6),
                Text('Play',
                  style: TextStyle(color: Colors.white,
                    fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Trailer button
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.dividerColor.withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam_rounded,
                    color: AppTheme.textSecondary, size: 20),
                SizedBox(width: 4),
                Text('Trailer',
                  style: TextStyle(color: AppTheme.textSecondary,
                    fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Watchlist button
        GestureDetector(
          onTap: () =>
              context.read<MovieDetailCubit>().toggleFavorite(movie),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isFavorite
                    ? AppTheme.primaryColor.withValues(alpha: 0.4)
                    : AppTheme.dividerColor.withValues(alpha: 0.3)),
            ),
            child: Icon(
              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isFavorite
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
