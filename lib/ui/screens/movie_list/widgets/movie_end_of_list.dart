import 'package:flixora/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class MovieEndOfList extends StatelessWidget {
  const MovieEndOfList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(children: [
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You've seen it all!",
            style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ]),
      ),
    );
  }
}