import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.export.dart';


final allChatRepository = Provider<AllChatRepository>((ref) {
  return AllChatRepository(apiClient: ref.watch(apiClientProvider));
});

class AllChatRepository {
  final ApiClient apiClient;

  AllChatRepository({required this.apiClient});

  Future<ApiResponse<dynamic>> getAllChat() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getAllChatEndpoint,
    );
  }

  Future<ApiResponse<dynamic>> getAllGroupChat() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getAllGroupChatEndpoint,
    );
  }

}