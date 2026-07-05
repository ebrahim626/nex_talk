import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/network/api_client.export.dart';


final directChatRepository = Provider<DirectChatRepository>((ref) {
  return DirectChatRepository(apiClient: ref.watch(apiClientProvider));
});

class DirectChatRepository {
  final ApiClient apiClient;

  DirectChatRepository({required this.apiClient});

  Future<ApiResponse<dynamic>> getAllChat(String userId) async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getChatEndpoint(userId: userId),
    );
  }

}