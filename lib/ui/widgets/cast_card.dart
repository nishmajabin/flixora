import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flixora/core/constants/app_theme.dart';
import 'package:flixora/core/utils/image_url_helper.dart';
import 'package:flixora/data/models/cast_model.dart';

/// A card displaying a cast member's photo, name, and character.
class CastCard extends StatelessWidget {
  final CastMember cast;

  const CastCard({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    final profileUrl = cast.profilePath != null
        ? ImageUrlHelper.getPosterUrl(cast.profilePath, size: '/w185')
        : null;

    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.surfaceLight.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: profileUrl != null
                  ? CachedNetworkImage(
                      imageUrl: profileUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppTheme.shimmerBase,
                        child: const Icon(Icons.person_rounded,
                            color: AppTheme.textMuted, size: 28),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppTheme.shimmerBase,
                        child: const Icon(Icons.person_rounded,
                            color: AppTheme.textMuted, size: 28),
                      ),
                    )
                  : Container(
                      color: AppTheme.shimmerBase,
                      child: const Icon(Icons.person_rounded,
                          color: AppTheme.textMuted, size: 28),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cast.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (cast.character != null && cast.character!.isNotEmpty)
            Text(
              cast.character!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}
