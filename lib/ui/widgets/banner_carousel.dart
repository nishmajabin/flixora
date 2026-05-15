import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/logic/cubit/home/home_cubit.dart';
import 'package:flixora/logic/cubit/home/home_state.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/utils/genre_utils.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/movie_model.dart';

/// Hotstar-style auto-sliding banner carousel.
///
/// Displays now-playing movies with full-screen backdrops,
/// gradient overlays, movie details, and page indicators.
class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.bannerMovies != curr.bannerMovies ||
          prev.currentBannerIndex != curr.currentBannerIndex,
      builder: (context, state) {
        if (state.bannerMovies.isEmpty) return const SizedBox.shrink();

        final cubit = context.read<HomeCubit>();
        final movies = state.bannerMovies.take(8).toList();

        return SizedBox(
          height: AppTheme.bannerHeight,
          child: Stack(
            children: [
              // ── PageView ──────────────────────────────────────────────
              GestureDetector(
                onPanDown: (_) => cubit.pauseBannerAutoScroll(),
                onPanEnd: (_) => cubit.resumeBannerAutoScroll(),
                onPanCancel: () => cubit.resumeBannerAutoScroll(),
                child: PageView.builder(
                  controller: cubit.bannerPageController,
                  itemCount: movies.length,
                  onPageChanged: cubit.updateBannerIndex,
                  itemBuilder: (context, index) {
                    return _BannerSlide(movie: movies[index]);
                  },
                ),
              ),

              // ── Bottom Info Overlay ───────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BannerOverlay(
                  movie: movies[state.currentBannerIndex.clamp(0, movies.length - 1)],
                ),
              ),

              // ── Page Indicators ───────────────────────────────────────
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: _PageIndicators(
                  count: movies.length,
                  activeIndex: state.currentBannerIndex,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Banner Slide ──────────────────────────────────────────────────────────────

class _BannerSlide extends StatelessWidget {
  final Movie movie;
  const _BannerSlide({required this.movie});

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

// ── Banner Overlay ────────────────────────────────────────────────────────────

class _BannerOverlay extends StatelessWidget {
  final Movie movie;
  const _BannerOverlay({required this.movie});

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
              _BannerButton(
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
              _BannerButton(
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

// ── Banner Action Button ──────────────────────────────────────────────────────

class _BannerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _BannerButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: filled ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: filled
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Page Indicators ───────────────────────────────────────────────────────────

class _PageIndicators extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _PageIndicators({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 4,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primaryColor
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
