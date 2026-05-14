import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/home/home_cubit.dart';
import 'package:flixora/bloc/home/home_state.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/ui/widgets/banner_carousel.dart';
import 'package:flixora/ui/widgets/error_display.dart';
import 'package:flixora/ui/widgets/movie_section.dart';
import 'package:flixora/ui/widgets/shimmer_loading.dart';

/// OTT-style home screen with banner carousel and horizontal movie sections.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.initial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<HomeCubit>().loadHome();
          });
          return const HomeShimmer();
        }

        if (state.status == HomeStatus.loading) {
          return const HomeShimmer();
        }

        if (state.status == HomeStatus.error) {
          return ErrorDisplay(
            message: state.errorMessage ?? 'Failed to load.',
            onRetry: () => context.read<HomeCubit>().loadHome(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().loadHome(),
          color: AppTheme.primaryColor,
          backgroundColor: AppTheme.surfaceColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Banner Carousel
                const BannerCarousel(),

                // ── Trending
                MovieSection(
                  title: 'Trending Now',
                  movies: state.trendingMovies,
                  icon: Icons.trending_up_rounded,
                ),

                // ── Popular
                MovieSection(
                  title: 'Popular',
                  movies: state.popularMovies,
                  icon: Icons.local_fire_department_rounded,
                ),

                // ── Top Rated
                MovieSection(
                  title: 'Top Rated',
                  movies: state.topRatedMovies,
                  icon: Icons.star_rounded,
                ),

                // ── Upcoming
                MovieSection(
                  title: 'Coming Soon',
                  movies: state.upcomingMovies,
                  icon: Icons.upcoming_rounded,
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }
}
