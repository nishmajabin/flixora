import 'package:flixora/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class MovieDetailInfoRow extends StatelessWidget {
  final String label;
  final String value;
  const MovieDetailInfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              )),
          ),
          Expanded(
            child: Text(value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
          ),
        ],
      ),
    );
  }
}