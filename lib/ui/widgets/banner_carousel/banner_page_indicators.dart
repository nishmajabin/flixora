import 'package:flixora/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class PageIndicators extends StatelessWidget {
  final int count;
  final int activeIndex;

  const PageIndicators({required this.count, required this.activeIndex, super.key});

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