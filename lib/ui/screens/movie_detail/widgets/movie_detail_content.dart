import 'package:cached_network_image/cached_network_image.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/utils/genre_utils.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/cast_model.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/logic/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:flixora/ui/screens/movie_detail/widgets/movie_detail_action_buttons.dart';
import 'package:flixora/ui/screens/movie_detail/widgets/movie_detail_info_table.dart';
import 'package:flixora/ui/screens/movie_detail/widgets/movie_detail_poster_title_row.dart';
import 'package:flixora/ui/screens/movie_detail/widgets/movie_detail_similar_card.dart';
import 'package:flixora/ui/screens/movie_detail/widgets/movie_detail_stats_row.dart';
import 'package:flixora/ui/widgets/cast_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailContent extends StatelessWidget {
  final Movie movie;
  final List<CastMember> cast;
  final List<Movie> similarMovies;
  final bool isFavorite;

  const MovieDetailContent({
    required this.movie,
    required this.cast,
    required this.similarMovies,
    required this.isFavorite,
    super.key
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
                MovieDetailPosterTitleRow(
                    movie: movie, posterUrl: poster, genres: genres),
                const SizedBox(height: 20),

                // Action Buttons
                MovieDetailActionButtons(movie: movie, isFavorite: isFavorite),
                const SizedBox(height: 24),

                // Stats
                MovieDetailStatsRow(movie: movie),
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
                MovieDetailInfoTable(movie: movie),
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
                          MovieDetailSimilarCard(movie: similarMovies[i]),
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