import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_talk/src/features/auth/login_section/auth_model/request/auth_request_model.dart';
import '../../../../core/network/api_client.export.dart';


final authRepository = Provider<AuthRepository>((ref) {
  return AuthRepository(apiClient: ref.watch(apiClientProvider));
});

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<ApiResponse<dynamic>> register(AuthRequestModel authRequest) async {
    return await apiClient.post(
      apiType: APIType.public,
      path: ApiEndpoints.authRegisterEndpoint,
      data: authRequest.toJson(),
    );
  }

  Future<ApiResponse<dynamic>> login(AuthRequestModel authRequest) async {
    return await apiClient.post(
      apiType: APIType.public,
      path: ApiEndpoints.loginEndpoint,
      data: authRequest.toJson(),
    );
  }
}