import 'package:flutter/material.dart';

import 'package:flixora/core/constants/app_theme.dart';

/// A reusable bottom loading indicator shown during pagination.
///
/// Displayed at the bottom of a scrollable list while the next
/// page of data is being fetched.
class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLG),
      alignment: Alignment.center,
      child: const SizedBox(
        height: 28,
        width: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
