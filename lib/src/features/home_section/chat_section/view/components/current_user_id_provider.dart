import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserIdProvider = StateProvider<String?>((ref) => null);

final selectedTabProvider = StateProvider<int>((ref) => 0);