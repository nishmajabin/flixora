import 'package:flutter/material.dart';
import 'package:flixora/core/constants/app_theme.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final int? voteCount;
  final double iconSize;
  final double fontSize;

  const RatingBar({
    super.key,
    required this.rating,
    this.voteCount,
    this.iconSize = 18,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppTheme.ratingStarColor,
          size: iconSize,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (voteCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '(${_formatVoteCount(voteCount!)})',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: fontSize - 2,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  /// Formats large vote counts with K/M suffixes.
  String _formatVoteCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
