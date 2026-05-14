import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/watchlist/watchlist_cubit.dart';
import 'package:flixora/bloc/watchlist/watchlist_state.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/movie_model.dart';

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
                    return _EmptyWatchlist();
                  }

                  return _WatchlistGrid(movies: state.movies);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bookmark_border_rounded,
                size: 56, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your watchlist is empty',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start adding movies you want to watch!',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _WatchlistGrid extends StatelessWidget {
  final List<Movie> movies;
  const _WatchlistGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final posterUrl = ImageUrlHelper.getPosterUrl(movie.posterPath);

        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.movieDetail,
            arguments: movie.id,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: posterUrl != null
                      ? CachedNetworkImage(
                          imageUrl: posterUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Container(
                          color: AppTheme.shimmerBase,
                          child: const Center(
                            child: Icon(Icons.movie_rounded,
                                color: AppTheme.textMuted),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
