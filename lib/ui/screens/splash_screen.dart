import 'package:flutter/material.dart';
import 'package:flixora/core/constants/app_theme.dart';

/// Animated splash screen with cinematic logo reveal.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to main shell after a delay
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.5 + (value * 0.5),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              // App Name
              const Text(
                'FLIXORA',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Cinema, Anywhere',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
