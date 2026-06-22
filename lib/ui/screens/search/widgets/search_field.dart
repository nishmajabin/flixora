import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/logic/bloc/movie/movie_bloc.dart';
import 'package:flixora/logic/bloc/movie/movie_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        onChanged: (query) {
          if (query.trim().isEmpty) {
            context.read<MovieBloc>().add(const ClearSearch());
          } else {
            // MovieBloc already has built-in 400ms debounce
            context.read<MovieBloc>().add(SearchMovies(query: query));
          }
        },
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
        cursorColor: AppTheme.primaryColor,
        decoration: const InputDecoration(
          hintText: 'Movies, shows, and more...',
          hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 15),
          prefixIcon: Icon(Icons.search_rounded,
              color: AppTheme.textMuted, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}