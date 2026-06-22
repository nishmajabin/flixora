import 'package:flixora/ui/screens/profile/widgets/profile_stat_item.dart';
import 'package:flutter/material.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileStatItem(
          icon: Icons.movie_rounded,
          value: '24',
          label: 'Watched',
        ),
        const SizedBox(width: 12),
        ProfileStatItem(
          icon: Icons.bookmark_rounded,
          value: '12',
          label: 'Watchlist',
        ),
        const SizedBox(width: 12),
        ProfileStatItem(icon: Icons.star_rounded, value: '8', label: 'Reviews'),
      ],
    );
  }
}
