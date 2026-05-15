import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/logic/bloc/movie/movie_bloc.dart';
import 'package:flixora/logic/bloc/movie/movie_event.dart';
import 'package:flixora/logic/bloc/movie/movie_state.dart';
import 'package:flixora/logic/cubit/movie_list/movie_list_cubit.dart';
import 'package:flixora/ui/screens/movie_list/widgets/movie_end_of_list.dart';
import 'package:flixora/ui/screens/movie_list/widgets/movie_list_empty_search.dart';
import 'package:flixora/ui/screens/movie_list/widgets/movie_list_grid.dart';
import 'package:flixora/ui/screens/movie_list/widgets/movie_list_inline_error.dart';
import 'package:flixora/ui/widgets/bottom_loader.dart';
import 'package:flixora/ui/widgets/error_display.dart';
import 'package:flixora/ui/widgets/movie_card.dart';
import 'package:flixora/ui/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieListBody extends StatelessWidget {
  final bool isSearchActive;

  const MovieListBody({required this.isSearchActive, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        // ── Search States ──────────────────────────────────────────────
        if (state is MovieSearchLoading) return const MovieListShimmer();
        if (state is MovieSearchEmpty) return MovieListEmptySearch(query: state.query);
        if (state is MovieSearchLoaded) return MovieListGrid(movies: state.movies);

        // ── Trending / Pagination States ───────────────────────────────
        if (state is MovieInitial || state is MovieLoading) {
          return const MovieListShimmer();
        }

        if (state is MovieError && state.previousMovies.isEmpty) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () =>
                context.read<MovieBloc>().add(const FetchMovies()),
          );
        }

        // Resolve movie list + pagination flags from concrete state types.
        final List<Movie> movies;
        final bool isLoadingMore;
        final bool hasReachedMax;

        if (state is MovieLoaded) {
          movies = state.movies;
          isLoadingMore = false;
          hasReachedMax = state.hasReachedMax;
        } else if (state is MovieLoadingMore) {
          movies = state.movies;
          isLoadingMore = true;
          hasReachedMax = false;
        } else if (state is MovieError) {
          movies = state.previousMovies;
          isLoadingMore = false;
          hasReachedMax = false;
        } else {
          return const SizedBox.shrink();
        }

        if (movies.isEmpty) {
          return const ErrorDisplay(
            message: 'No movies found.',
            icon: Icons.movie_filter_rounded,
          );
        }

        // Cubit-owned ScrollController — no dispose responsibility here.
        final scrollController =
            context.read<MovieListCubit>().scrollController;

        return RefreshIndicator(
          onRefresh: () async =>
              context.read<MovieBloc>().add(const RefreshMovies()),
          color: AppTheme.primaryColor,
          backgroundColor: AppTheme.surfaceColor,
          child: CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => MovieCard(movie: movies[index]),
                    childCount: movies.length,
                  ),
                ),
              ),
              if (isLoadingMore)
                const SliverToBoxAdapter(child: BottomLoader()),
              if (state is MovieError && state.previousMovies.isNotEmpty)
                SliverToBoxAdapter(
                  child: MovieListInlineError(
                    message: state.message,
                    onRetry: () => context
                        .read<MovieBloc>()
                        .add(const FetchMoreMovies()),
                  ),
                ),
              if (hasReachedMax && movies.isNotEmpty)
                const SliverToBoxAdapter(child: MovieEndOfList()),
            ],
          ),
        );
      },
    );
  }
}