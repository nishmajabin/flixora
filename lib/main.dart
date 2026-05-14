import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flixora/bloc/movie_bloc.dart';
import 'package:flixora/bloc/watchlist/watchlist_cubit.dart';
import 'package:flixora/core/constants/app_constants.dart';
import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/routes/app_routes.dart';
import 'package:flixora/core/routes/app_router.dart';
import 'package:flixora/data/database/movie_database_helper_impl.dart';
import 'package:flixora/data/services/movie_api_service_impl.dart';
import 'package:flixora/data/services/movie_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite FFI for desktop platforms (Windows/Linux/macOS)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Force dark status bar for immersive cinema feel
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.scaffoldBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // ── Initialize Dependencies ───────────────────────────────────────────
  final databaseHelper = MovieDatabaseHelperImpl();
  await databaseHelper.initDatabase();

  final cachedMovies = await databaseHelper.getCachedMovies();
  debugPrint('[Flixora] 🗄️ STARTUP: Found ${cachedMovies.length} cached movies in DB.');

  final apiService = MovieApiServiceImpl();

  final repository = MovieRepository(
    apiService: apiService,
    databaseHelper: databaseHelper,
  );

  runApp(FlixoraApp(repository: repository));
}

class FlixoraApp extends StatelessWidget {
  final MovieRepository repository;

  const FlixoraApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MovieBloc>(
            create: (context) => MovieBloc(
              repository: context.read<MovieRepository>(),
            ),
          ),
          BlocProvider<WatchlistCubit>(
            create: (context) => WatchlistCubit(
              repository: context.read<MovieRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,

          // ── Theme ─────────────────────────────────────────────────────
          theme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,

          // ── Navigation ────────────────────────────────────────────────
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
