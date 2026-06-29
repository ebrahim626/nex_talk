import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view/components/current_user_id_provider.dart';

typedef AllChatProviderNotifier =
AutoDisposeAsyncNotifierProviderFamily<AllChatProvider, void, String>;

final allChatProvider = AllChatProviderNotifier(AllChatProvider.new);

class AllChatProvider extends AutoDisposeFamilyAsyncNotifier<void, String> {
  int selectedTabBar = 0;
  String userId = "";

  @override
  FutureOr<void> build(arg) {
    userId = arg;
  }

  void setTab(int index) {
    selectedTabBar = index;
    ref.read(selectedTabProvider.notifier).state = index; // 👈 sync global
    ref.notifyListeners();
  }

}