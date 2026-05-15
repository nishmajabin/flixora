import 'package:flixora/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class MovieDetailStatBox extends StatelessWidget {
  final String label;
  final String value;
  const MovieDetailStatBox({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
              style: const TextStyle(color: AppTheme.textPrimary,
                fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(label,
              style: const TextStyle(
                  color: AppTheme.textMuted, fontSize: 11),
              textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}