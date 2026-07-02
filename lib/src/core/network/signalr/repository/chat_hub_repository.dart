import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/hive_storage.dart';
import '../../api_client.export.dart';
import '../chat_hub_service.dart';

final chatHubServiceProvider = Provider<ChatHubService>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  final service = ChatHubService(
    baseUrl: ApiEndpoints.baseUrl,
    getToken: () => cacheService.bearerToken,
  );
  ref.onDispose(service.dispose);
  return service;
});