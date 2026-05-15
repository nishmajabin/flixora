import 'package:flixora/ui/screens/bottom_nav/animated_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/logic/cubit/navigation/navigation_cubit.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/ui/screens/downloads/screen/downloads_screen.dart';
import 'package:flixora/ui/screens/home/screen/home_screen.dart';
import 'package:flixora/ui/screens/profile_screen.dart';
import 'package:flixora/ui/screens/search_screen.dart';
import 'package:flixora/ui/screens/watchlist_screen.dart';

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
          bottomNavigationBar: AnimatedBottomNav(
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
