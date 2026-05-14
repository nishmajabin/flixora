import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/home/home_state.dart';
import 'package:flixora/core/utils/app_logger.dart';
import 'package:flixora/data/services/movie_repository.dart';

/// Cubit that manages the home screen state.
///
/// Fetches all movie sections in parallel and manages the
/// auto-sliding banner carousel via a periodic timer.
class HomeCubit extends Cubit<HomeState> {
  final MovieRepository _repository;

  /// PageController for the banner carousel — owned here so
  /// all widgets can remain StatelessWidget.
  final PageController bannerPageController = PageController(viewportFraction: 1.0);

  Timer? _bannerTimer;
  static const _bannerDuration = Duration(seconds: 5);

  HomeCubit({required MovieRepository repository})
      : _repository = repository,
        super(const HomeState());

  /// Fetches all home screen sections in parallel.
  Future<void> loadHome() async {
    if (state.status == HomeStatus.loading) return;
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // Fetch all sections concurrently for speed
      final results = await Future.wait([
        _repository.getNowPlayingMovies(),   // 0 — banner
        _repository.getTrendingMovies(),      // 1
        _repository.getPopularMovies(),       // 2
        _repository.getTopRatedMovies(),      // 3
        _repository.getUpcomingMovies(),      // 4
      ]);

      emit(state.copyWith(
        status: HomeStatus.loaded,
        bannerMovies: results[0],
        trendingMovies: results[1],
        popularMovies: results[2],
        topRatedMovies: results[3],
        upcomingMovies: results[4],
      ));

      AppLogger.info('Home loaded — all sections fetched.');
      _startBannerAutoScroll();
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Failed to load home content.',
      ));
      AppLogger.error('Home load failed: $e');
    }
  }

  /// Updates the current banner page index (driven by PageView onPageChanged).
  void updateBannerIndex(int index) {
    emit(state.copyWith(currentBannerIndex: index));
  }

  /// Starts the auto-sliding timer for the banner carousel.
  void _startBannerAutoScroll() {
    _bannerTimer?.cancel();
    if (state.bannerMovies.length <= 1) return;

    _bannerTimer = Timer.periodic(_bannerDuration, (_) {
      if (!bannerPageController.hasClients) return;
      final nextPage = (state.currentBannerIndex + 1) % state.bannerMovies.length;
      bannerPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  /// Pauses the auto-scroll (e.g., when user is interacting).
  void pauseBannerAutoScroll() {
    _bannerTimer?.cancel();
  }

  /// Resumes the auto-scroll after user interaction.
  void resumeBannerAutoScroll() {
    _startBannerAutoScroll();
  }

  @override
  Future<void> close() {
    _bannerTimer?.cancel();
    bannerPageController.dispose();
    return super.close();
  }
}
