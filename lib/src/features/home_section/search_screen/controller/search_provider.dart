import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SearchProviderNotifier = AutoDisposeAsyncNotifierProvider<SearchProvider, void>;

final searchProvider = SearchProviderNotifier(SearchProvider.new);

class SearchProvider extends AutoDisposeAsyncNotifier<void> {
  int selectedTabBar = 0;

  @override
  FutureOr<void> build() {
    // initialization logic
  }

  void setTab(int index) {
    selectedTabBar = index;
    ref.notifyListeners();
  }

}