import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/movie_bloc.dart';
import 'package:flixora/bloc/movie_event.dart';
import 'package:flixora/bloc/movie_list_cubit.dart';
import 'package:flixora/bloc/movie_list_cubit_state.dart';
import 'package:flixora/bloc/movie_state.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/ui/widgets/bottom_loader.dart';
import 'package:flixora/ui/widgets/error_display.dart';
import 'package:flixora/ui/widgets/movie_card.dart';
import 'package:flixora/ui/widgets/shimmer_loading.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  MovieListScreen — 100 % StatelessWidget tree
//
//  All controllers (ScrollController, TextEditingController, FocusNode) live
//  inside MovieListCubit and are disposed in Cubit.close().
//  All state reactions go through BlocBuilder / BlocListener.
//  Zero setState calls exist anywhere in this file.
// ═══════════════════════════════════════════════════════════════════════════

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fire initial load once — MovieBloc ignores this if already loaded/loading.
    context.read<MovieBloc>().add(const FetchMovies());

    // Register the scroll listener once here, using the cubit-owned controller.
    // BlocListener fires only on state changes (not every build), so this
    // listener registration runs exactly once per screen mount.
    return BlocListener<MovieListCubit, MovieListState>(
      listenWhen: (prev, curr) => prev.isSearchActive != curr.isSearchActive,
      listener: (context, listUiState) {
        // Attach / detach the pagination scroll listener whenever search
        // mode toggles, so pagination never fires during search.
        final cubit = context.read<MovieListCubit>();
        final controller = cubit.scrollController;

        // Remove any stale listener before (re-)adding to prevent duplicates.
        controller.removeListener(() {});

        if (!listUiState.isSearchActive) {
          controller.addListener(() => _onScroll(context, cubit));
        }
      },
      child: BlocBuilder<MovieListCubit, MovieListState>(
        builder: (context, listUiState) {
          return Scaffold(
            appBar: listUiState.isSearchActive
                ? _SearchAppBar(listUiState: listUiState)
                : const _DefaultAppBar(),
            body: _MovieListBody(isSearchActive: listUiState.isSearchActive),
          );
        },
      ),
    );
  }

  /// Dispatches [FetchMoreMovies] when the user scrolls near the bottom.
  static void _onScroll(BuildContext context, MovieListCubit cubit) {
    final controller = cubit.scrollController;
    if (!controller.hasClients) return;
    final nearBottom =
        controller.offset >= controller.position.maxScrollExtent - 200;
    if (nearBottom) {
      context.read<MovieBloc>().add(const FetchMoreMovies());
    }
  }
}

// ── Default AppBar ─────────────────────────────────────────────────────────

class _DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DefaultAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(children: [
        Icon(Icons.play_circle_filled_rounded,
            color: AppTheme.primaryColor, size: 28),
        const SizedBox(width: 8),
        Text(
          'Flixora',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ]),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          tooltip: 'Search movies',
          onPressed: () => context.read<MovieListCubit>().openSearch(),
        ),
      ],
    );
  }
}

// ── Search AppBar ──────────────────────────────────────────────────────────

class _SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MovieListState listUiState;

  const _SearchAppBar({required this.listUiState});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _onChanged(BuildContext context, String query) {
    context.read<MovieListCubit>().updateQuery(query);
    if (query.trim().isEmpty) {
      context.read<MovieBloc>().add(const ClearSearch());
    } else {
      context.read<MovieBloc>().add(SearchMovies(query: query));
    }
  }

  void _clearSearch(BuildContext context) {
    context.read<MovieListCubit>().clearQuery();
    context.read<MovieBloc>().add(const ClearSearch());
  }

  void _closeSearch(BuildContext context) {
    context.read<MovieBloc>().add(const ClearSearch());
    context.read<MovieListCubit>().closeSearch();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieListCubit>();

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => _closeSearch(context),
      ),
      title: TextField(
        // Controller and FocusNode live in MovieListCubit — no disposal needed here.
        controller: cubit.searchController,
        focusNode: cubit.searchFocusNode,
        onChanged: (q) => _onChanged(context, q),
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
        cursorColor: AppTheme.primaryColor,
        decoration: InputDecoration(
          hintText: 'Search movies...',
          hintStyle: TextStyle(color: AppTheme.textMuted),
          border: InputBorder.none,
          // Driven by BLoC state — no setState, no controller.text check.
          suffixIcon: listUiState.showClearIcon
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 20),
                  color: AppTheme.textMuted,
                  onPressed: () => _clearSearch(context),
                )
              : null,
        ),
      ),
    );
  }
}

// ── Movie List Body ────────────────────────────────────────────────────────

/// Pure [StatelessWidget] body.
///
/// Reads the [ScrollController] from [MovieListCubit] and hands it to
/// [CustomScrollView] — no resource ownership, no lifecycle management.
class _MovieListBody extends StatelessWidget {
  final bool isSearchActive;

  const _MovieListBody({required this.isSearchActive});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        // ── Search States ──────────────────────────────────────────────
        if (state is MovieSearchLoading) return const MovieListShimmer();
        if (state is MovieSearchEmpty) return _EmptySearch(query: state.query);
        if (state is MovieSearchLoaded) return _MovieGrid(movies: state.movies);

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
                  child: _InlineError(
                    message: state.message,
                    onRetry: () => context
                        .read<MovieBloc>()
                        .add(const FetchMoreMovies()),
                  ),
                ),
              if (hasReachedMax && movies.isNotEmpty)
                const SliverToBoxAdapter(child: _EndOfList()),
            ],
          ),
        );
      },
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────

class _MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  const _MovieGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) => MovieCard(movie: movies[index]),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(16),
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
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different movie name or check spelling.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
        ]),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: AppTheme.errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.warning_amber_rounded,
            color: AppTheme.errorColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
        ),
        TextButton(
          onPressed: onRetry,
          child: const Text('Retry',
              style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}

class _EndOfList extends StatelessWidget {
  const _EndOfList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(children: [
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You've seen it all!",
            style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ]),
      ),
    );
  }
}