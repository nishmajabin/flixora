import 'package:equatable/equatable.dart';
import 'package:flixora/data/models/movie_model.dart';

/// State for the home screen — holds all movie sections.
class HomeState extends Equatable {
  final HomeStatus status;
  final List<Movie> bannerMovies;
  final List<Movie> trendingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;
  final int currentBannerIndex;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.bannerMovies = const [],
    this.trendingMovies = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.upcomingMovies = const [],
    this.currentBannerIndex = 0,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Movie>? bannerMovies,
    List<Movie>? trendingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? upcomingMovies,
    int? currentBannerIndex,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      bannerMovies: bannerMovies ?? this.bannerMovies,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bannerMovies,
        trendingMovies,
        popularMovies,
        topRatedMovies,
        upcomingMovies,
        currentBannerIndex,
        errorMessage,
      ];
}

enum HomeStatus { initial, loading, loaded, error }
