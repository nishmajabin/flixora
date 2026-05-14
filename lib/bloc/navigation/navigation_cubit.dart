import 'package:flutter_bloc/flutter_bloc.dart';

/// Simple cubit managing the active bottom navigation tab index.
///
/// Persists tab selection so [IndexedStack] keeps tab state alive.
class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  /// Updates the active tab index.
  void updateTab(int index) {
    if (state != index) emit(index);
  }
}
