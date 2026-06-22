import 'package:flixora/ui/screens/profile/widgets/profile_premium_card.dart';
import 'package:flixora/ui/screens/profile/widgets/profile_settings_tile.dart';
import 'package:flixora/ui/screens/profile/widgets/profile_stats_row.dart';
import 'package:flixora/ui/screens/profile/widgets/profile_user_info_card.dart';
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
              const ProfileUserInfoCard(),
              const SizedBox(height: 20),

              // ── Premium Card
              const ProfilePremiumCard(),
              const SizedBox(height: 24),

              // ── Stats Row
              const ProfileStatsRow(),
              const SizedBox(height: 24),

              // ── Settings Section
              const Text('Settings',
                style: TextStyle(color: AppTheme.textPrimary,
                  fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const ProfileSettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage alerts',
              ),
              const ProfileSettingsTile(
                icon: Icons.download_outlined,
                title: 'Download Quality',
                subtitle: 'HD',
              ),
              const ProfileSettingsTile(
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: 'English',
              ),
              const ProfileSettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Appearance',
                subtitle: 'Dark',
              ),
              ProfileSettingsTile(
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
              ProfileSettingsTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
              ),
              ProfileSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
              ),
              ProfileSettingsTile(
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
