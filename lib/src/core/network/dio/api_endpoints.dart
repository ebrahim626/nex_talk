part of '../api_client.export.dart';

class ApiEndpoints {

  ///base url
  static const String baseUrl = 'https://nextalk-production-9e30.up.railway.app';


  static const String authRegisterEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static String getAllChatEndpoint({required String userId}) => '/api/chat/direct/$userId';

  static const String chatHubPath = '/hubs/chat';
}
