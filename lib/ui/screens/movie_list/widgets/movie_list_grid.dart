import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/ui/widgets/movie_card.dart';
import 'package:flutter/material.dart';

class MovieListGrid extends StatelessWidget {
  final List<Movie> movies;
  const MovieListGrid({required this.movies, super.key});

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