import 'package:flixora/ui/screens/movie_list/widgets/movie_list_body.dart';
import 'package:flixora/ui/screens/movie_list/widgets/movie_list_default_app_bar.dart';
import 'package:flixora/ui/screens/movie_list/widgets/movie_list_search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/logic/bloc/movie/movie_bloc.dart';
import 'package:flixora/logic/bloc/movie/movie_event.dart';
import 'package:flixora/logic/cubit/movie_list/movie_list_cubit.dart';
import 'package:flixora/logic/cubit/movie_list/movie_list_cubit_state.dart';

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
                ? MovieListSearchAppBar(listUiState: listUiState)
                : const MovieListDefaultAppBar(),
            body: MovieListBody(isSearchActive: listUiState.isSearchActive),
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
