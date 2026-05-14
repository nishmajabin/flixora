import 'package:flixora/core/constants/app_constants.dart';

class ImageUrlHelper {
  ImageUrlHelper._();
  static String? getPosterUrl(
    String? posterPath, {
    String size = AppConstants.posterSizeMedium,
  }) {
    if (posterPath == null || posterPath.isEmpty) return null;
    return '${AppConstants.imageBaseUrl}$size$posterPath';
  }
  static String? getBackdropUrl(
    String? backdropPath, {
    String size = AppConstants.backdropSizeMedium,
  }) {
    if (backdropPath == null || backdropPath.isEmpty) return null;
    return '${AppConstants.imageBaseUrl}$size$backdropPath';
  }
}
