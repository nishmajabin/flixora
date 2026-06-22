import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flixora/logic/cubit/home/home_cubit.dart';
import 'package:flixora/logic/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:flixora/logic/cubit/movie_list/movie_list_cubit.dart';
import 'package:flixora/logic/cubit/navigation/navigation_cubit.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/data/services/movie_repository.dart';
import 'package:flixora/ui/screens/bottom_nav/main_shell.dart';
import 'package:flixora/ui/screens/movie_detail/screen/movie_detail_screen.dart';
import 'package:flixora/ui/screens/movie_list/screen/movie_list_screen.dart';
import 'package:flixora/ui/screens/splash/screen/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name) {
      // ── Splash ──────────────────────────────────────────────────────────
      case AppRoutes.splash:
        return _fadeRoute(
          settings: settings,
          screen: const SplashScreen(),
        );

      // ── Main Shell (Bottom Nav) ─────────────────────────────────────────
      case AppRoutes.main:
        return _fadeRoute(
          settings: settings,
          screen: MultiBlocProvider(
            providers: [
              BlocProvider<NavigationCubit>(
                create: (_) => NavigationCubit(),
              ),
              BlocProvider<HomeCubit>(
                create: (context) => HomeCubit(
                  repository: context.read<MovieRepository>(),
                ),
              ),
            ],
            child: const MainShell(),
          ),
        );

      // ── Movie Detail ────────────────────────────────────────────────────
      case AppRoutes.movieDetail:
        final movieId = settings.arguments as int;
        return _slideRoute(
          settings: settings,
          screen: BlocProvider<MovieDetailCubit>(
            create: (context) => MovieDetailCubit(
              repository: context.read<MovieRepository>(),
            )..fetchMovieDetail(movieId),
            child: MovieDetailScreen(movieId: movieId),
          ),
        );

      // ── Movie List (See All) ────────────────────────────────────────────
      case AppRoutes.movieList:
        return _slideRoute(
          settings: settings,
          screen: BlocProvider<MovieListCubit>(
            create: (_) => MovieListCubit(),
            child: const MovieListScreen(),
          ),
        );

      // ── Fallback ────────────────────────────────────────────────────────
      default:
        return _fadeRoute(
          settings: settings,
          screen: const _UnknownRouteScreen(),
        );
    }
  }

  /// Fade transition for root-level routes (splash → main).
  static PageRouteBuilder<dynamic> _fadeRoute({
    required RouteSettings settings,
    required Widget screen,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// Slide-up transition for detail/push routes.
  static PageRouteBuilder<dynamic> _slideRoute({
    required RouteSettings settings,
    required Widget screen,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: const Center(
        child: Text('404 — Page not found', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
