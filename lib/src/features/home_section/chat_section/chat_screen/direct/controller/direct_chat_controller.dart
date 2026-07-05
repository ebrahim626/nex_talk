import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef AllChatProviderNotifier =
AutoDisposeAsyncNotifierProviderFamily<AllChatProvider, void, String>;

final allChatProvider = AllChatProviderNotifier(AllChatProvider.new);

class AllChatProvider extends AutoDisposeFamilyAsyncNotifier<void, String> {

  @override
  FutureOr<void> build(arg) async {

  }



}