import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flixora/core/constants/app_constants.dart';
import 'package:flixora/core/utils/api_exception.dart';
import 'package:flixora/core/utils/app_logger.dart';
import 'package:flixora/data/database/movie_database_helper.dart';
import 'package:flixora/data/models/movie_model.dart';


class MovieDatabaseHelperImpl implements MovieDatabaseHelper {
  Database? _database;

  static const String _cachedAtColumn = 'cached_at';

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    await initDatabase();
    return _database!;
  }

  // ── Initialization ──────────────────────────────────────────────────────

  @override
  Future<void> initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, AppConstants.databaseName);

      _database = await openDatabase(
        path,
        version: 2, // Bumped for favorites table
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );

      AppLogger.database('Database initialized at $path');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize database', error: e, stackTrace: stackTrace);
      throw const CacheException(message: 'Failed to initialize local database.');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.moviesTable} (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        overview TEXT,
        poster_path TEXT,
        backdrop_path TEXT,
        vote_average REAL DEFAULT 0.0,
        vote_count INTEGER DEFAULT 0,
        release_date TEXT,
        genre_ids TEXT,
        popularity REAL DEFAULT 0.0,
        adult INTEGER DEFAULT 0,
        original_language TEXT,
        $_cachedAtColumn INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.favoriteMoviesTable} (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        overview TEXT,
        poster_path TEXT,
        backdrop_path TEXT,
        vote_average REAL DEFAULT 0.0,
        vote_count INTEGER DEFAULT 0,
        release_date TEXT,
        genre_ids TEXT,
        popularity REAL DEFAULT 0.0,
        adult INTEGER DEFAULT 0,
        original_language TEXT,
        added_at INTEGER NOT NULL
      )
    ''');

    AppLogger.database('Movies and favorites tables created.');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add favorites table for v2
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${AppConstants.favoriteMoviesTable} (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          overview TEXT,
          poster_path TEXT,
          backdrop_path TEXT,
          vote_average REAL DEFAULT 0.0,
          vote_count INTEGER DEFAULT 0,
          release_date TEXT,
          genre_ids TEXT,
          popularity REAL DEFAULT 0.0,
          adult INTEGER DEFAULT 0,
          original_language TEXT,
          added_at INTEGER NOT NULL
        )
      ''');
      AppLogger.database('Database upgraded from v$oldVersion to v$newVersion — favorites table added.');
    }
  }

  // ── Cache CRUD ─────────────────────────────────────────────────────────

  @override
  Future<void> cacheMovies(
    List<Movie> movies, {
    bool clearExisting = false,
  }) async {
    if (movies.isEmpty) {
      AppLogger.database('cacheMovies called with empty list — skipping.');
      return;
    }

    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Use a transaction so DELETE + INSERTs are atomic.
      // If any INSERT fails, the DELETE is also rolled back.
      await db.transaction((txn) async {
        if (clearExisting) {
          await txn.delete(AppConstants.moviesTable);
          AppLogger.database('Cache cleared inside transaction (clearExisting=true).');
        }

        for (final movie in movies) {
          final row = movie.toDbMap();
          row[_cachedAtColumn] = now;
          await txn.insert(
            AppConstants.moviesTable,
            row,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      AppLogger.database(
        'Cached ${movies.length} movies '
        '(clearExisting=$clearExisting, timestamp=$now).',
      );

      // Verify: read back count to confirm data persisted
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.moviesTable}'),
      );
      AppLogger.database('Verification: $count total movies now in DB.');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to cache movies', error: e, stackTrace: stackTrace);
      // Don't throw — caching failure should not break the app.
    }
  }

  @override
  Future<List<Movie>> getCachedMovies() async {
    try {
      final db = await database;
      final results = await db.query(
        AppConstants.moviesTable,
        orderBy: 'popularity DESC',
      );

      AppLogger.database('Retrieved ${results.length} cached movies from DB.');
      return results.map((row) => Movie.fromDbMap(row)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to read cached movies', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<Movie?> getCachedMovieById(int id) async {
    try {
      final db = await database;
      final results = await db.query(
        AppConstants.moviesTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        AppLogger.database('No cached movie found for id=$id.');
        return null;
      }
      AppLogger.database('Found cached movie id=$id.');
      return Movie.fromDbMap(results.first);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to read cached movie id=$id', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final db = await database;
      final count = await db.delete(AppConstants.moviesTable);
      AppLogger.database('Cache cleared — $count rows deleted.');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear cache', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final db = await database;
      final results = await db.query(
        AppConstants.moviesTable,
        columns: [_cachedAtColumn],
        orderBy: '$_cachedAtColumn DESC',
        limit: 1,
      );

      if (results.isEmpty) return false;

      final cachedAt = results.first[_cachedAtColumn] as int;
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(cachedAt);
      final isValid = DateTime.now().difference(cachedTime) < AppConstants.cacheDuration;

      AppLogger.database('Cache valid: $isValid (cached at: $cachedTime)');
      return isValid;
    } catch (e) {
      return false;
    }
  }

  // ── Favorites CRUD ─────────────────────────────────────────────────────

  @override
  Future<void> addFavorite(Movie movie) async {
    try {
      final db = await database;
      final row = movie.toDbMap();
      row['added_at'] = DateTime.now().millisecondsSinceEpoch;
      await db.insert(
        AppConstants.favoriteMoviesTable,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      AppLogger.database('Added movie "${movie.title}" to favorites.');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to add favorite', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> removeFavorite(int movieId) async {
    try {
      final db = await database;
      await db.delete(
        AppConstants.favoriteMoviesTable,
        where: 'id = ?',
        whereArgs: [movieId],
      );
      AppLogger.database('Removed movie id=$movieId from favorites.');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to remove favorite', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    try {
      final db = await database;
      final results = await db.query(
        AppConstants.favoriteMoviesTable,
        where: 'id = ?',
        whereArgs: [movieId],
        limit: 1,
      );
      return results.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Movie>> getFavorites() async {
    try {
      final db = await database;
      final results = await db.query(
        AppConstants.favoriteMoviesTable,
        orderBy: 'added_at DESC',
      );
      AppLogger.database('Retrieved ${results.length} favorite movies.');
      return results.map((row) => Movie.fromDbMap(row)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to read favorites', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
      AppLogger.database('Database connection closed.');
    }
  }
}
