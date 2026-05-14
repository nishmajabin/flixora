import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/movie_list_cubit_state.dart';

/// Cubit that owns **all** UI-level resources for [MovieListScreen].
///
/// Owns:
///   - [scrollController]  — for infinite-scroll pagination detection.
///   - [searchController]  — for the search [TextField].
///   - [searchFocusNode]   — to autofocus the search field when opened.
///   - [isSearchActive]    — whether the search [AppBar] is shown.
///   - [searchQuery]       — live text so clear-icon visibility is state-driven.
///
/// By owning controllers here, every screen widget can be a pure
/// [StatelessWidget].  Controllers are disposed in [close], which
/// [BlocProvider] calls automatically when the cubit leaves the tree.
class MovieListCubit extends Cubit<MovieListState> {
  // ── Platform resources ────────────────────────────────────────────────

  /// Shared scroll controller — attach to [CustomScrollView].
  final ScrollController scrollController = ScrollController();

  /// Shared text controller — attach to the search [TextField].
  final TextEditingController searchController = TextEditingController();

  /// Focus node — request focus when search opens.
  final FocusNode searchFocusNode = FocusNode();

  // ── Constructor ────────────────────────────────────────────────────────

  MovieListCubit() : super(const MovieListState());

  // ── Search lifecycle ───────────────────────────────────────────────────

  /// Opens the search [AppBar], clears any previous query, and focuses
  /// the [TextField] on the next frame.
  void openSearch() {
    searchController.clear();
    emit(state.copyWith(isSearchActive: true, searchQuery: ''));
    // Request focus after the new AppBar has been built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

  /// Hides the search [AppBar] and resets all query state.
  void closeSearch() {
    searchController.clear();
    searchFocusNode.unfocus();
    emit(state.copyWith(isSearchActive: false, searchQuery: ''));
  }

  /// Called on every keystroke — mirrors text into state so that the
  /// clear-icon visibility is driven by BLoC, not [TextField.controller].
  void updateQuery(String query) {
    if (state.searchQuery == query) return; // skip redundant emits
    emit(state.copyWith(searchQuery: query));
  }

  /// Clears the text field and resets query state without closing the bar.
  void clearQuery() {
    searchController.clear();
    emit(state.copyWith(searchQuery: ''));
  }

  // ── Dispose ────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    scrollController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    return super.close();
  }
}