import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/movie_detail_cubit.dart';
import 'package:flixora/bloc/movie_detail_state.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/utils/genre_utils.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/cast_model.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/ui/widgets/cast_card.dart';
import 'package:flixora/ui/widgets/error_display.dart';
import 'package:flixora/ui/widgets/shimmer_loading.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<MovieDetailCubit>().fetchMovieDetail(movieId);
            });
            return const MovieDetailShimmer();
          }
          if (state is MovieDetailLoading) return const MovieDetailShimmer();
          if (state is MovieDetailError) {
            return SafeArea(
              child: Column(children: [
                _buildBackButton(context),
                Expanded(
                  child: ErrorDisplay(
                    message: state.message,
                    onRetry: () => context
                        .read<MovieDetailCubit>()
                        .fetchMovieDetail(movieId),
                  ),
                ),
              ]),
            );
          }
          if (state is MovieDetailLoaded) {
            return _DetailContent(
              movie: state.movie,
              cast: state.cast,
              similarMovies: state.similarMovies,
              isFavorite: state.isFavorite,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

// ── Detail Content ────────────────────────────────────────────────────────────

class _DetailContent extends StatelessWidget {
  final Movie movie;
  final List<CastMember> cast;
  final List<Movie> similarMovies;
  final bool isFavorite;

  const _DetailContent({
    required this.movie,
    required this.cast,
    required this.similarMovies,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final backdrop = ImageUrlHelper.getBackdropUrl(
        movie.backdropPath, size: '/original');
    final poster = ImageUrlHelper.getPosterUrl(movie.posterPath);
    final genres = GenreUtils.getGenreNames(movie.genreIds);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Cinematic Backdrop ───────────────────────────────────────
        SliverAppBar(
          expandedHeight: 360,
          pinned: true,
          backgroundColor: AppTheme.scaffoldBackground,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              radius: 18,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                color: Colors.white,
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                radius: 18,
                child: IconButton(
                  icon: Icon(
                    isFavorite
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 20,
                  ),
                  color: isFavorite ? AppTheme.primaryColor : Colors.white,
                  padding: EdgeInsets.zero,
                  onPressed: () => context
                      .read<MovieDetailCubit>()
                      .toggleFavorite(movie),
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (backdrop != null)
                  CachedNetworkImage(
                    imageUrl: backdrop,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppTheme.shimmerBase),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppTheme.shimmerBase),
                  )
                else
                  Container(color: AppTheme.shimmerBase),
                Container(decoration: const BoxDecoration(
                    gradient: AppTheme.bannerGradient)),
              ],
            ),
          ),
        ),

        // ── Body ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster + Title
                _PosterTitleRow(
                    movie: movie, posterUrl: poster, genres: genres),
                const SizedBox(height: 20),

                // Action Buttons
                _ActionButtons(movie: movie, isFavorite: isFavorite),
                const SizedBox(height: 24),

                // Stats
                _StatsRow(movie: movie),
                const SizedBox(height: 24),

                // Overview
                if (movie.overview != null &&
                    movie.overview!.isNotEmpty) ...[
                  const Text('Storyline',
                    style: TextStyle(color: AppTheme.textPrimary,
                      fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview!,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Cast
                if (cast.isNotEmpty) ...[
                  const Text('Cast',
                    style: TextStyle(color: AppTheme.textPrimary,
                      fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: cast.length.clamp(0, 15),
                      itemBuilder: (_, i) => CastCard(cast: cast[i]),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Movie Info
                const Text('Details',
                  style: TextStyle(color: AppTheme.textPrimary,
                    fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _InfoTable(movie: movie),
                const SizedBox(height: 24),

                // Similar Movies
                if (similarMovies.isNotEmpty) ...[
                  const Text('More Like This',
                    style: TextStyle(color: AppTheme.textPrimary,
                      fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: AppTheme.movieCardHeight + 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: similarMovies.length.clamp(0, 12),
                      itemBuilder: (_, i) =>
                          _SimilarCard(movie: similarMovies[i]),
                    ),
                  ),
                ],

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Poster + Title ────────────────────────────────────────────────────────────

class _PosterTitleRow extends StatelessWidget {
  final Movie movie;
  final String? posterUrl;
  final List<String> genres;

  const _PosterTitleRow({
    required this.movie,
    this.posterUrl,
    this.genres = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'movie_poster_${movie.id}',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: posterUrl != null
                  ? CachedNetworkImage(
                      imageUrl: posterUrl!,
                      width: 120,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 120,
                      height: 180,
                      color: AppTheme.shimmerBase,
                      child: const Icon(Icons.movie_rounded,
                          color: AppTheme.textMuted, size: 40),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                movie.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              // Rating
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppTheme.ratingStarColor, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ' / 10',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${_formatCount(movie.voteCount)})',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Release date
              if (movie.releaseDate != null &&
                  movie.releaseDate!.isNotEmpty)
                _InfoChip(
                  icon: Icons.calendar_today_rounded,
                  label: _formatDate(movie.releaseDate!),
                ),
              const SizedBox(height: 6),
              if (movie.originalLanguage != null)
                _InfoChip(
                  icon: Icons.language_rounded,
                  label: movie.originalLanguage!.toUpperCase(),
                ),
              const SizedBox(height: 10),
              // Genre chips
              if (genres.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: genres.take(3).map((g) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(g,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      )),
                  )).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatDate(String s) {
    try {
      final d = DateTime.parse(s);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[d.month - 1]} ${d.day}, ${d.year}';
    } catch (_) {
      return s;
    }
  }

  static String _formatCount(int c) {
    if (c >= 1000000) return '${(c / 1000000).toStringAsFixed(1)}M';
    if (c >= 1000) return '${(c / 1000).toStringAsFixed(1)}K';
    return c.toString();
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          )),
      ],
    );
  }
}

// ── Action Buttons ────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;

  const _ActionButtons({required this.movie, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Play button
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 24),
                SizedBox(width: 6),
                Text('Play',
                  style: TextStyle(color: Colors.white,
                    fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Trailer button
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.dividerColor.withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam_rounded,
                    color: AppTheme.textSecondary, size: 20),
                SizedBox(width: 4),
                Text('Trailer',
                  style: TextStyle(color: AppTheme.textSecondary,
                    fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Watchlist button
        GestureDetector(
          onTap: () =>
              context.read<MovieDetailCubit>().toggleFavorite(movie),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isFavorite
                    ? AppTheme.primaryColor.withValues(alpha: 0.4)
                    : AppTheme.dividerColor.withValues(alpha: 0.3)),
            ),
            child: Icon(
              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isFavorite
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final Movie movie;
  const _StatsRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBox(label: '⭐ Rating',
            value: movie.voteAverage.toStringAsFixed(1)),
        const SizedBox(width: 8),
        _StatBox(label: '🗳️ Votes',
            value: _fmt(movie.voteCount)),
        const SizedBox(width: 8),
        _StatBox(label: '🔥 Popularity',
            value: movie.popularity.toStringAsFixed(0)),
      ],
    );
  }

  static String _fmt(int c) {
    if (c >= 1000000) return '${(c / 1000000).toStringAsFixed(1)}M';
    if (c >= 1000) return '${(c / 1000).toStringAsFixed(1)}K';
    return c.toString();
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
              style: const TextStyle(color: AppTheme.textPrimary,
                fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(label,
              style: const TextStyle(
                  color: AppTheme.textMuted, fontSize: 11),
              textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Info Table ─────────────────────────────────────────────────────────────────

class _InfoTable extends StatelessWidget {
  final Movie movie;
  const _InfoTable({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _InfoRow('Release Date', movie.releaseDate ?? 'N/A'),
          _InfoRow('Language',
              movie.originalLanguage?.toUpperCase() ?? 'N/A'),
          _InfoRow('Rating',
              '${movie.voteAverage.toStringAsFixed(1)} / 10'),
          _InfoRow('Votes', movie.voteCount.toString()),
          _InfoRow('Popularity',
              movie.popularity.toStringAsFixed(1)),
          _InfoRow('Adult Content', movie.adult ? 'Yes' : 'No'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              )),
          ),
          Expanded(
            child: Text(value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
          ),
        ],
      ),
    );
  }
}

// ── Similar Movie Card ────────────────────────────────────────────────────────

class _SimilarCard extends StatelessWidget {
  final Movie movie;
  const _SimilarCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final posterUrl = ImageUrlHelper.getPosterUrl(movie.posterPath);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.movieDetail,
        arguments: movie.id,
      ),
      child: Container(
        width: AppTheme.movieCardWidth,
        margin: const EdgeInsets.only(right: 10),
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
      ),
    );
  }
}