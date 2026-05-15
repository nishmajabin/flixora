import 'package:equatable/equatable.dart';

/// UI-only state for [MovieListCubit].
///
/// Tracks whether the search bar is currently active and the live
/// search query text so widgets can react without local [setState].
class MovieListState extends Equatable {
  /// Whether the inline search bar is visible.
  final bool isSearchActive;

  /// The current raw text in the search field.
  /// Empty string when search is inactive or cleared.
  final String searchQuery;

  const MovieListState({
    this.isSearchActive = false,
    this.searchQuery = '',
  });

  MovieListState copyWith({
    bool? isSearchActive,
    String? searchQuery,
  }) {
    return MovieListState(
      isSearchActive: isSearchActive ?? this.isSearchActive,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Whether the clear (✕) icon should be shown in the search field.
  bool get showClearIcon => searchQuery.isNotEmpty;

  @override
  List<Object?> get props => [isSearchActive, searchQuery];
}