import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flixora/core/constants/app_theme.dart';

/// Reusable shimmer loading placeholder for movie cards.
class MovieCardShimmer extends StatelessWidget {
  const MovieCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.shimmerBase,
      highlightColor: AppTheme.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.shimmerBase,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }
}

/// Grid of shimmer placeholders.
class MovieListShimmer extends StatelessWidget {
  final int itemCount;
  const MovieListShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppTheme.spacingSM,
        mainAxisSpacing: AppTheme.spacingSM,
      ),
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, __) => const MovieCardShimmer(),
    );
  }
}

/// Shimmer for the home screen banner + sections.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.shimmerBase,
      highlightColor: AppTheme.shimmerHighlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner placeholder
            Container(
              height: AppTheme.bannerHeight,
              width: double.infinity,
              color: AppTheme.shimmerBase,
            ),
            const SizedBox(height: 24),
            // Section shimmer x3
            ...List.generate(3, (_) => _sectionShimmer()),
          ],
        ),
      ),
    );
  }

  Widget _sectionShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 20,
            width: 140,
            decoration: BoxDecoration(
              color: AppTheme.shimmerBase,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: AppTheme.movieCardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: 5,
            itemBuilder: (_, __) => Container(
              width: AppTheme.movieCardWidth,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppTheme.shimmerBase,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Shimmer for the movie detail screen.
class MovieDetailShimmer extends StatelessWidget {
  const MovieDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.shimmerBase,
      highlightColor: AppTheme.shimmerHighlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 300, width: double.infinity, color: AppTheme.shimmerBase),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 24, width: 220,
                    decoration: BoxDecoration(color: AppTheme.shimmerBase,
                      borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 8),
                  Container(height: 16, width: 160,
                    decoration: BoxDecoration(color: AppTheme.shimmerBase,
                      borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 24),
                  Row(
                    children: List.generate(3, (_) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(height: 36, width: 100,
                        decoration: BoxDecoration(color: AppTheme.shimmerBase,
                          borderRadius: BorderRadius.circular(8))),
                    )),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(5, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(height: 14, width: i == 4 ? 180 : double.infinity,
                      decoration: BoxDecoration(color: AppTheme.shimmerBase,
                        borderRadius: BorderRadius.circular(4))),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for search results.
class SearchShimmer extends StatelessWidget {
  const SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.shimmerBase,
      highlightColor: AppTheme.shimmerHighlight,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 80, height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.shimmerBase,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: 180,
                      decoration: BoxDecoration(color: AppTheme.shimmerBase,
                        borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 120,
                      decoration: BoxDecoration(color: AppTheme.shimmerBase,
                        borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 80,
                      decoration: BoxDecoration(color: AppTheme.shimmerBase,
                        borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
