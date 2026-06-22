import 'package:flixora/logic/bloc/movie/movie_bloc.dart';
import 'package:flixora/logic/bloc/movie/movie_state.dart';
import 'package:flixora/ui/screens/search/widgets/search_empty_state.dart';
import 'package:flixora/ui/screens/search/widgets/search_results.dart';
import 'package:flixora/ui/screens/search/widgets/search_trending_section.dart';
import 'package:flixora/ui/widgets/shimmer/search_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieSearchLoading) return const SearchShimmer();

        if (state is MovieSearchEmpty) {
          return SearchEmptyState(query: state.query);
        }

        if (state is MovieSearchLoaded) {
          return SearchResults(movies: state.movies);
        }

        // Default: show trending suggestions
        return const SearchTrendingSection();
      },
    );
  }
}