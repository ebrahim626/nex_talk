part of '../api_client.export.dart';

class ApiEndpoints {

  ///base url
  // static const String baseUrl = 'https://nextalk-production-9e30.up.railway.app';

  //local host
  static const String baseUrl = 'http://192.168.0.103:5096';

  static const String authRegisterEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static const String getAllChatEndpoint = '/api/chat/conversations';
  static const String getAllGroupChatEndpoint = '/api/Group';
  static String getChatEndpoint({required String userId}) => '/api/chat/direct/$userId';
  static const String addNewContactEndpoint = "/api/chat/direct";


  static const String chatHubPath = '/hubs/chat';
}
