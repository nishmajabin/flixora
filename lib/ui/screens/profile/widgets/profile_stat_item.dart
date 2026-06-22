import 'package:flixora/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const ProfileStatItem({
    required this.icon,
    required this.value,
    required this.label,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 22),
            const SizedBox(height: 6),
            Text(value,
              style: const TextStyle(color: AppTheme.textPrimary,
                fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}