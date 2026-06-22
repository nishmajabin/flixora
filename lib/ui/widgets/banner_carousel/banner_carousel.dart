import 'package:flixora/ui/widgets/banner_carousel/banner_overlay.dart';
import 'package:flixora/ui/widgets/banner_carousel/banner_page_indicators.dart';
import 'package:flixora/ui/widgets/banner_carousel/banner_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/logic/cubit/home/home_cubit.dart';
import 'package:flixora/logic/cubit/home/home_state.dart';
import 'package:flixora/core/constants/app_theme.dart';

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
                    return BannerSlide(movie: movies[index]);
                  },
                ),
              ),

              // ── Bottom Info Overlay ───────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BannerOverlay(
                  movie: movies[state.currentBannerIndex.clamp(0, movies.length - 1)],
                ),
              ),

              // ── Page Indicators ───────────────────────────────────────
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: PageIndicators(
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
