import 'package:flixora/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class MovieListInlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const MovieListInlineError({required this.message, required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: AppTheme.errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.warning_amber_rounded,
            color: AppTheme.errorColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
        ),
        TextButton(
          onPressed: onRetry,
          child: const Text('Retry',
              style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}
