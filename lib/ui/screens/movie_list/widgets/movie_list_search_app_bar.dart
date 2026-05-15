import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/logic/bloc/movie/movie_bloc.dart';
import 'package:flixora/logic/bloc/movie/movie_event.dart';
import 'package:flixora/logic/cubit/movie_list/movie_list_cubit.dart';
import 'package:flixora/logic/cubit/movie_list/movie_list_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieListSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MovieListState listUiState;

  const MovieListSearchAppBar({required this.listUiState, super.key});

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