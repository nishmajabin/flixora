import 'package:flixora/ui/widgets/movie_section/horizontal_movie_card.dart';
import 'package:flutter/material.dart';

import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/data/models/movie_model.dart';

/// A horizontal scrolling movie section like "Trending", "Popular", etc.
///
/// Displays a section title with an optional "See All" action,
/// followed by a horizontally-scrolling list of movie poster cards.
class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final VoidCallback? onSeeAll;
  final IconData? icon;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    this.onSeeAll,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 12, 12),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          color: AppTheme.accentCyan,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: AppTheme.accentCyan, size: 12),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // ── Horizontal Movie List ───────────────────────────────────
        SizedBox(
          height: AppTheme.movieCardHeight + 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const BouncingScrollPhysics(),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return HorizontalMovieCard(movie: movies[index]);
            },
          ),
        ),
      ],
    );
  }
}