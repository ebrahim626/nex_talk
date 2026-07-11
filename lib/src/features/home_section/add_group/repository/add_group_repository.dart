import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.export.dart';


final addGroupRepository = Provider<AddGroupRepository>((ref) {
  return AddGroupRepository(apiClient: ref.watch(apiClientProvider));
});

class AddGroupRepository {
  final ApiClient apiClient;

  AddGroupRepository({required this.apiClient});

  Future<ApiResponse<dynamic>> addNewGroup(String groupName) async {
    return await apiClient.post(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getAllGroupChatEndpoint,
      data: {
        "name": groupName,
      }
    );
  }

}