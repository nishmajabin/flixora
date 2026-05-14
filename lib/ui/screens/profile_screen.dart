import 'package:flutter/material.dart';
import 'package:flixora/core/constants/app_theme.dart';

/// Professional profile screen with user info, settings, and premium card.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Profile',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              // ── User Info Card
              _UserInfoCard(),
              const SizedBox(height: 20),

              // ── Premium Card
              _PremiumCard(),
              const SizedBox(height: 24),

              // ── Stats Row
              _StatsRow(),
              const SizedBox(height: 24),

              // ── Settings Section
              const Text('Settings',
                style: TextStyle(color: AppTheme.textPrimary,
                  fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage alerts',
              ),
              _SettingsTile(
                icon: Icons.download_outlined,
                title: 'Download Quality',
                subtitle: 'HD',
              ),
              _SettingsTile(
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: 'English',
              ),
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Appearance',
                subtitle: 'Dark',
              ),
              _SettingsTile(
                icon: Icons.storage_outlined,
                title: 'Storage',
                subtitle: 'Manage downloads',
              ),
              const SizedBox(height: 24),

              // ── More Section
              const Text('More',
                style: TextStyle(color: AppTheme.textPrimary,
                  fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
              ),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'v1.0.0',
              ),
              const SizedBox(height: 16),

              // ── Logout
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout_rounded,
                      color: AppTheme.errorColor),
                  label: const Text('Sign Out',
                    style: TextStyle(color: AppTheme.errorColor,
                      fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: AppTheme.errorColor.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
            ),
            child: const Center(
              child: Text('F',
                style: TextStyle(color: Colors.white,
                  fontSize: 28, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Flixora User',
                  style: TextStyle(color: AppTheme.textPrimary,
                    fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('user@flixora.com',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined,
                color: AppTheme.textMuted, size: 20),
          ),
        ],
      ),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF2D1B69)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppTheme.premiumGold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.diamond_rounded,
                  color: AppTheme.premiumGold, size: 24),
              const SizedBox(width: 8),
              const Text('Flixora Premium',
                style: TextStyle(color: AppTheme.premiumGold,
                  fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Unlock 4K streaming, offline downloads, and ad-free experience.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13,
              height: 1.4),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A84B), Color(0xFFF0C97A)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Upgrade Now',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black,
                fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(icon: Icons.movie_rounded, value: '24', label: 'Watched'),
        const SizedBox(width: 12),
        _StatItem(icon: Icons.bookmark_rounded, value: '12', label: 'Watchlist'),
        const SizedBox(width: 12),
        _StatItem(icon: Icons.star_rounded, value: '8', label: 'Reviews'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
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
