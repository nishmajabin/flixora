import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/ui/widgets/shimmer/movie_card_shimmer.dart';
import 'package:flutter/material.dart';

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