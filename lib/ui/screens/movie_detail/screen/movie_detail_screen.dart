import 'package:flixora/ui/screens/movie_detail/widgets/movie_detail_content.dart';
import 'package:flixora/ui/widgets/shimmer/movie_detail_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flixora/logic/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:flixora/logic/cubit/movie_detail/movie_detail_state.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/ui/widgets/error_display.dart';

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
            return MovieDetailContent(
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

