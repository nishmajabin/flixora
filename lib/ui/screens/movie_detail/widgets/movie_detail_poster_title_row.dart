import 'package:cached_network_image/cached_network_image.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/ui/screens/movie_detail/widgets/movie_detail_info_chip.dart';
import 'package:flutter/material.dart';

class MovieDetailPosterTitleRow extends StatelessWidget {
  final Movie movie;
  final String? posterUrl;
  final List<String> genres;

  const MovieDetailPosterTitleRow({
    required this.movie,
    this.posterUrl,
    this.genres = const [],
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'movie_poster_${movie.id}',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: posterUrl != null
                  ? CachedNetworkImage(
                      imageUrl: posterUrl!,
                      width: 120,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 120,
                      height: 180,
                      color: AppTheme.shimmerBase,
                      child: const Icon(Icons.movie_rounded,
                          color: AppTheme.textMuted, size: 40),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                movie.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              // Rating
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppTheme.ratingStarColor, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ' / 10',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${_formatCount(movie.voteCount)})',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Release date
              if (movie.releaseDate != null &&
                  movie.releaseDate!.isNotEmpty)
                MovieDetailInfoChip(
                  icon: Icons.calendar_today_rounded,
                  label: _formatDate(movie.releaseDate!),
                ),
              const SizedBox(height: 6),
              if (movie.originalLanguage != null)
                MovieDetailInfoChip(
                  icon: Icons.language_rounded,
                  label: movie.originalLanguage!.toUpperCase(),
                ),
              const SizedBox(height: 10),
              // Genre chips
              if (genres.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: genres.take(3).map((g) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(g,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      )),
                  )).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatDate(String s) {
    try {
      final d = DateTime.parse(s);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[d.month - 1]} ${d.day}, ${d.year}';
    } catch (_) {
      return s;
    }
  }

  static String _formatCount(int c) {
    if (c >= 1000000) return '${(c / 1000000).toStringAsFixed(1)}M';
    if (c >= 1000) return '${(c / 1000).toStringAsFixed(1)}K';
    return c.toString();
  }
}