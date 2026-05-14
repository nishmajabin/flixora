/// Maps TMDB genre IDs to human-readable names.
///
/// These are the official TMDB movie genre IDs as of the current API version.
class GenreUtils {
  GenreUtils._();

  static const Map<int, String> _genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };

  /// Returns the genre name for a given ID, or null if not found.
  static String? getGenreName(int id) => _genreMap[id];

  /// Converts a list of genre IDs to a comma-separated string of genre names.
  static String getGenreString(List<int> genreIds, {int maxCount = 3}) {
    return genreIds
        .take(maxCount)
        .map((id) => _genreMap[id])
        .where((name) => name != null)
        .join(' • ');
  }

  /// Returns a list of genre name strings from genre IDs.
  static List<String> getGenreNames(List<int> genreIds) {
    return genreIds
        .map((id) => _genreMap[id])
        .where((name) => name != null)
        .cast<String>()
        .toList();
  }
}
