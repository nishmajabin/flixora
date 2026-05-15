import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/logic/cubit/movie_list/movie_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieListDefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MovieListDefaultAppBar({super.key});

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
