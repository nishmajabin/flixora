import 'package:flixora/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const ProfileSettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.textSecondary, size: 20),
        ),
        title: Text(title,
          style: const TextStyle(color: AppTheme.textPrimary,
            fontSize: 15, fontWeight: FontWeight.w500)),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: const TextStyle(
                    color: AppTheme.textMuted, fontSize: 12))
            : null,
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted, size: 14),
      ),
    );
  }
}