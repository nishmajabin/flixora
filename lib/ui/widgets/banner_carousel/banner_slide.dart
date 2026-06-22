import 'package:cached_network_image/cached_network_image.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flutter/material.dart';

class BannerSlide extends StatelessWidget {
  final Movie movie;
  const BannerSlide({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final backdropUrl = ImageUrlHelper.getBackdropUrl(
      movie.backdropPath,
      size: '/original',
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.movieDetail,
        arguments: movie.id,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Backdrop Image
          if (backdropUrl != null)
            CachedNetworkImage(
              imageUrl: backdropUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppTheme.shimmerBase),
              errorWidget: (_, __, ___) => Container(
                color: AppTheme.shimmerBase,
                child: const Icon(Icons.movie_rounded,
                    color: AppTheme.textMuted, size: 64),
              ),
            )
          else
            Container(color: AppTheme.shimmerBase),

          // ── Gradient Overlay
          Container(decoration: const BoxDecoration(gradient: AppTheme.bannerGradient)),

          // ── Top Gradient (for status bar readability)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Color(0x99000000), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }
}