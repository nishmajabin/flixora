import 'package:flixora/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class MovieDetailInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const MovieDetailInfoChip({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          )),
      ],
    );
  }
}
