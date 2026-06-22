import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/utils/genre_utils.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/ui/widgets/banner_carousel/banner_button.dart';
import 'package:flutter/material.dart';

class BannerOverlay extends StatelessWidget {
  final Movie movie;
  const BannerOverlay({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final genres = GenreUtils.getGenreString(movie.genreIds);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.2,
              shadows: [Shadow(blurRadius: 10, color: Colors.black)],
            ),
          ),
          const SizedBox(height: 8),

          // Genres + Rating
          Row(
            children: [
              if (genres.isNotEmpty) ...[
                Flexible(
                  child: Text(
                    genres,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.ratingStarColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppTheme.ratingStarColor.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppTheme.ratingStarColor, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppTheme.ratingStarColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              // Play Button
              BannerButton(
                icon: Icons.play_arrow_rounded,
                label: 'Play',
                filled: true,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.movieDetail,
                  arguments: movie.id,
                ),
              ),
              const SizedBox(width: 12),
              // Info Button
              BannerButton(
                icon: Icons.info_outline_rounded,
                label: 'Info',
                filled: false,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.movieDetail,
                  arguments: movie.id,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}