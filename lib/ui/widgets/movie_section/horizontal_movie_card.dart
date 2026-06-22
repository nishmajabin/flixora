import 'package:cached_network_image/cached_network_image.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flutter/material.dart';

class HorizontalMovieCard extends StatelessWidget {
  final Movie movie;
  const HorizontalMovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final posterUrl = ImageUrlHelper.getPosterUrl(movie.posterPath);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.movieDetail,
        arguments: movie.id,
      ),
      child: Container(
        width: AppTheme.movieCardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Poster Image
            Expanded(
              child: Hero(
                tag: 'movie_poster_${movie.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (posterUrl != null)
                          CachedNetworkImage(
                            imageUrl: posterUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: AppTheme.shimmerBase,
                              child: const Center(
                                child: Icon(Icons.movie_rounded,
                                    color: AppTheme.textMuted, size: 32),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: AppTheme.shimmerBase,
                              child: const Center(
                                child: Icon(Icons.broken_image_rounded,
                                    color: AppTheme.textMuted, size: 32),
                              ),
                            ),
                          )
                        else
                          Container(
                            color: AppTheme.shimmerBase,
                            child: const Center(
                              child: Icon(Icons.movie_rounded,
                                  color: AppTheme.textMuted, size: 32),
                            ),
                          ),

                        // Rating badge
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getRatingColor(movie.voteAverage)
                                  .withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Colors.white, size: 10),
                                const SizedBox(width: 2),
                                Text(
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Title
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 2, right: 2),
              child: Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // ── Year
            if (movie.releaseDate != null && movie.releaseDate!.length >= 4)
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  movie.releaseDate!.substring(0, 4),
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7.0) return AppTheme.successColor;
    if (rating >= 5.0) return AppTheme.ratingStarColor;
    return AppTheme.errorColor;
  }
}
