import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/movie_bloc.dart';
import 'package:flixora/bloc/movie_event.dart';
import 'package:flixora/bloc/movie_state.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/utils/genre_utils.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/ui/widgets/shimmer_loading.dart';

/// Professional search screen with trending searches and real-time results.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _SearchHeader(),
            Expanded(child: _SearchBody()),
          ],
        ),
      ),
    );
  }
}

// ── Search Header ─────────────────────────────────────────────────────────────

class _SearchHeader extends StatelessWidget {
  const _SearchHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          _SearchField(),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        onChanged: (query) {
          if (query.trim().isEmpty) {
            context.read<MovieBloc>().add(const ClearSearch());
          } else {
            // MovieBloc already has built-in 400ms debounce
            context.read<MovieBloc>().add(SearchMovies(query: query));
          }
        },
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
        cursorColor: AppTheme.primaryColor,
        decoration: const InputDecoration(
          hintText: 'Movies, shows, and more...',
          hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 15),
          prefixIcon: Icon(Icons.search_rounded,
              color: AppTheme.textMuted, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ── Search Body ───────────────────────────────────────────────────────────────

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieSearchLoading) return const SearchShimmer();

        if (state is MovieSearchEmpty) {
          return _EmptyState(query: state.query);
        }

        if (state is MovieSearchLoaded) {
          return _SearchResults(movies: state.movies);
        }

        // Default: show trending suggestions
        return const _TrendingSection();
      },
    );
  }
}

// ── Trending Section ──────────────────────────────────────────────────────────

class _TrendingSection extends StatelessWidget {
  const _TrendingSection();

  static const _trendingQueries = [
    'Avengers', 'Batman', 'Spider-Man', 'Inception',
    'Interstellar', 'Oppenheimer', 'Dune', 'John Wick',
    'The Dark Knight', 'Joker',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up_rounded,
                  color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Trending Searches',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trendingQueries.map((query) {
              return GestureDetector(
                onTap: () {
                  context.read<MovieBloc>().add(SearchMovies(query: query));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.dividerColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    query,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Search Results ────────────────────────────────────────────────────────────

class _SearchResults extends StatelessWidget {
  final List<Movie> movies;
  const _SearchResults({required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final posterUrl = ImageUrlHelper.getPosterUrl(movie.posterPath);
        final genres = GenreUtils.getGenreString(movie.genreIds, maxCount: 2);

        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.movieDetail,
            arguments: movie.id,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Row(
              children: [
                // Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: posterUrl != null
                      ? CachedNetworkImage(
                          imageUrl: posterUrl,
                          width: 70,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 70,
                          height: 100,
                          color: AppTheme.shimmerBase,
                          child: const Icon(Icons.movie_rounded,
                              color: AppTheme.textMuted),
                        ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (genres.isNotEmpty)
                        Text(
                          genres,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppTheme.ratingStarColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (movie.releaseDate != null &&
                              movie.releaseDate!.length >= 4) ...[
                            const SizedBox(width: 12),
                            Text(
                              movie.releaseDate!.substring(0, 4),
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_forward_ios_rounded,
                    color: AppTheme.textMuted, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded,
                  size: 48, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              'No results for "$query"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try a different search term.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
