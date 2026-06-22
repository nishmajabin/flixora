import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/logic/bloc/movie/movie_bloc.dart';
import 'package:flixora/logic/bloc/movie/movie_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTrendingSection extends StatelessWidget {
  const SearchTrendingSection({super.key});

  static const _trendingQueries = [
    'Avengers', 'Batman', 'Spider-Man', 'Inception',
    'Interstellar', 'Oppenheimer', 'Dune', 'John Wick',
    'The Dark Knight', 'Joker',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up_rounded,
                  color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Trending Searches',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trendingQueries.map((query) {
              return GestureDetector(
                onTap: () {
                  context.read<MovieBloc>().add(SearchMovies(query: query));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.dividerColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    query,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}