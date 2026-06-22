import 'package:flixora/ui/screens/watchlist/widgets/empty_watchlist.dart';
import 'package:flixora/ui/screens/watchlist/widgets/watchlist_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/logic/cubit/watchlist/watchlist_cubit.dart';
import 'package:flixora/logic/cubit/watchlist/watchlist_state.dart';
import 'package:flixora/core/constants/app_theme.dart';

/// Watchlist screen showing all bookmarked/favorited movies.
class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Text(
                'My Watchlist',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<WatchlistCubit, WatchlistState>(
                builder: (context, state) {
                  if (state.status == WatchlistStatus.initial) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<WatchlistCubit>().loadWatchlist();
                    });
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primaryColor),
                    );
                  }

                  if (state.movies.isEmpty) {
                    return EmptyWatchlist();
                  }

                  return WatchlistGrid(movies: state.movies);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
