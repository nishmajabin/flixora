import 'package:flixora/ui/screens/search/widgets/search_body.dart';
import 'package:flixora/ui/screens/search/widgets/search_header.dart';
import 'package:flutter/material.dart';
import 'package:flixora/core/constants/app_theme.dart';

/// Professional search screen with trending searches and real-time results.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            SearchHeader(),
            Expanded(child: SearchBody()),
          ],
        ),
      ),
    );
  }
}
