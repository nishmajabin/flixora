import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/ui/widgets/rating_bar.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final posterUrl = ImageUrlHelper.getPosterUrl(movie.posterPath);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.movieDetail, arguments: movie.id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'movie_poster_${movie.id}',
                child: posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: posterUrl, fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppTheme.shimmerBase, child: const Center(child: Icon(Icons.movie_rounded, color: AppTheme.textMuted, size: 40))),
                        errorWidget: (_, __, ___) => Container(color: AppTheme.shimmerBase, child: const Center(child: Icon(Icons.broken_image_rounded, color: AppTheme.textMuted, size: 40))),
                      )
                    : Container(color: AppTheme.shimmerBase, child: const Center(child: Icon(Icons.movie_rounded, color: AppTheme.textMuted, size: 40))),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7), Colors.black.withValues(alpha: 0.95)],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(8, 32, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, height: 1.2)),
                      const SizedBox(height: 4),
                      if (movie.overview != null && movie.overview!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(movie.overview!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10, height: 1.3)),
                        ),
                      RatingBar(rating: movie.voteAverage, iconSize: 14, fontSize: 12),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: _getRatingColor(movie.voteAverage), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                  child: Text(movie.voteAverage.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
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
