import 'package:flixora/core/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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