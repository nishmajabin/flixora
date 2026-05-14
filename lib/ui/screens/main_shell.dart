import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/navigation/navigation_cubit.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/ui/screens/downloads_screen.dart';
import 'package:flixora/ui/screens/home_screen.dart';
import 'package:flixora/ui/screens/profile_screen.dart';
import 'package:flixora/ui/screens/search_screen.dart';
import 'package:flixora/ui/screens/watchlist_screen.dart';

/// Main app shell with persistent bottom navigation bar.
///
/// Uses [IndexedStack] to keep tab state alive across switches.
/// Navigation index is driven by [NavigationCubit].
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _screens = [
    HomeScreen(),
    SearchScreen(),
    WatchlistScreen(),
    DownloadsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          backgroundColor: AppTheme.scaffoldBackground,
          extendBody: true,
          body: IndexedStack(
            index: currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: _AnimatedBottomNav(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<NavigationCubit>().updateTab(index);
            },
          ),
        );
      },
    );
  }
}

// ── Animated Bottom Navigation Bar ────────────────────────────────────────────

class _AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AnimatedBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.search_rounded, activeIcon: Icons.search_rounded, label: 'Search'),
    _NavItem(icon: Icons.bookmark_border_rounded, activeIcon: Icons.bookmark_rounded, label: 'Watchlist'),
    _NavItem(icon: Icons.download_outlined, activeIcon: Icons.download_rounded, label: 'Downloads'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
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

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
