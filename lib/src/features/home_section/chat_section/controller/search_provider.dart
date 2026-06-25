import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef AllChatProviderNotifier = AutoDisposeAsyncNotifierProvider<AllChatProvider, void>;

final allChatProvider = AllChatProviderNotifier(AllChatProvider.new);

class AllChatProvider extends AutoDisposeAsyncNotifier<void> {
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