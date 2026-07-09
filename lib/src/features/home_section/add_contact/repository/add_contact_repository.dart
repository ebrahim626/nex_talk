import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.export.dart';


final addContactRepository = Provider<AddContactRepository>((ref) {
  return AddContactRepository(apiClient: ref.watch(apiClientProvider));
});

class AddContactRepository {
  final ApiClient apiClient;

  AddContactRepository({required this.apiClient});

  Future<ApiResponse<dynamic>> addNewConversation(String userId, String? message) async {
    return await apiClient.post(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.addNewContactEndpoint,
      data: {
        "RecipientUsername": userId,
        "content": message ?? "",
      }
    );
  }

}