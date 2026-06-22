import 'package:cached_network_image/cached_network_image.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/utils/genre_utils.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatelessWidget {
  final List<Movie> movies;
  const SearchResults({required this.movies, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final posterUrl = ImageUrlHelper.getPosterUrl(movie.posterPath);
        final genres = GenreUtils.getGenreString(movie.genreIds, maxCount: 2);

        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.movieDetail,
            arguments: movie.id,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Row(
              children: [
                // Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: posterUrl != null
                      ? CachedNetworkImage(
                          imageUrl: posterUrl,
                          width: 70,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 70,
                          height: 100,
                          color: AppTheme.shimmerBase,
                          child: const Icon(Icons.movie_rounded,
                              color: AppTheme.textMuted),
                        ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (genres.isNotEmpty)
                        Text(
                          genres,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppTheme.ratingStarColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (movie.releaseDate != null &&
                              movie.releaseDate!.length >= 4) ...[
                            const SizedBox(width: 12),
                            Text(
                              movie.releaseDate!.substring(0, 4),
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_forward_ios_rounded,
                    color: AppTheme.textMuted, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
