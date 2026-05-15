import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/ui/screens/bottom_nav/nav_item.dart';
import 'package:flutter/material.dart';

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AnimatedBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key
  });

  static const _items = [
    BottomNavItem(icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: 'Home'),
    BottomNavItem(icon: Icons.search_rounded, activeIcon: Icons.search_rounded, label: 'Search'),
    BottomNavItem(icon: Icons.bookmark_border_rounded, activeIcon: Icons.bookmark_rounded, label: 'Watchlist'),
    BottomNavItem(icon: Icons.download_outlined, activeIcon: Icons.download_rounded, label: 'Downloads'),
    BottomNavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.navBarBackground.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: AppTheme.dividerColor.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated icon
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            key: ValueKey('${item.label}_$isActive'),
                            color: isActive
                                ? AppTheme.primaryColor
                                : AppTheme.textMuted,
                            size: isActive ? 26 : 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Label
                        Text(
                          item.label,
                          style: TextStyle(
                            color: isActive
                                ? AppTheme.primaryColor
                                : AppTheme.textMuted,
                            fontSize: 10,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        // Active indicator dot
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(top: 4),
                          width: isActive ? 16 : 0,
                          height: 2.5,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}