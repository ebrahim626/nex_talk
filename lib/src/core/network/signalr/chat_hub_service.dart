import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../api_client.export.dart';

class ChatHubService {
  late HubConnection _hubConnection;
  final String baseUrl;
  final Future<String?> Function() getToken;

  ChatHubService({required this.baseUrl, required this.getToken});

  final _directMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _groupMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _userOnlineController = StreamController<String>.broadcast();
  final _userOfflineController = StreamController<String>.broadcast();
  final _onlineUsersController = StreamController<List<String>>.broadcast();
  final _typingController = StreamController<String>.broadcast();
  final _typingGroupController = StreamController<Map<String, dynamic>>.broadcast();
  final _messageReadController = StreamController<String>.broadcast();
  final _connectionStateController = StreamController<HubConnectionState>.broadcast();

  Stream<Map<String, dynamic>> get onDirectMessage => _directMessageController.stream;
  Stream<Map<String, dynamic>> get onGroupMessage => _groupMessageController.stream;
  Stream<String> get onUserOnline => _userOnlineController.stream;
  Stream<String> get onUserOffline => _userOfflineController.stream;
  Stream<List<String>> get onOnlineUsers => _onlineUsersController.stream;
  Stream<String> get onTyping => _typingController.stream;
  Stream<Map<String, dynamic>> get onTypingGroup => _typingGroupController.stream;
  Stream<String> get onMessageRead => _messageReadController.stream;
  Stream<HubConnectionState> get connectionStateChanges => _connectionStateController.stream;

  Future<void> connect() async {
    // Check connectivity first
    final hasConnection = await _hasNetworkConnection();
    if (!hasConnection) {
      log('[ChatHubService] No network connection available');
      throw Exception('No network connection');
    }

    final fullUrl = '$baseUrl${ApiEndpoints.chatHubPath}';

    const maxAttempts = 3;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        _hubConnection = HubConnectionBuilder()
            .withUrl(
          fullUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => (await getToken()) ?? '',
            transport: HttpTransportType.WebSockets,
          ),
        )
            .withAutomaticReconnect()
            .build();

        _registerListeners();

        _hubConnection.onreconnecting(({error}) {
          _connectionStateController.add(HubConnectionState.Reconnecting);
        });

        _hubConnection.onreconnected(({connectionId}) {
          _connectionStateController.add(HubConnectionState.Connected);
        });

        _hubConnection.onclose(({error}) {
          _connectionStateController.add(HubConnectionState.Disconnected);
        });

        await _hubConnection.start();
        _connectionStateController.add(HubConnectionState.Connected);
        return;

      } catch (e) {
        if (attempt == maxAttempts) rethrow;
        await Future.delayed(Duration(milliseconds: 700 * attempt));
      }
    }
  }

  Future<bool> _hasNetworkConnection() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result.any((r) => r != ConnectivityResult.none);
    } catch (e) {
      return true; // Assume connection exists if we can't check
    }
  }

  void _registerListeners() {
    _hubConnection.on('ReceiveDirectMessage', (args) {
      final data = args?[0] as Map<String, dynamic>?;
      if (data != null) _directMessageController.add(data);
    });

    _hubConnection.on('ReceiveGroupMessage', (args) {
      final data = args?[0] as Map<String, dynamic>?;
      if (data != null) _groupMessageController.add(data);
    });

    _hubConnection.on('UserOnline', (args) {
      final userId = args?[0] as String?;
      if (userId != null) _userOnlineController.add(userId);
    });

    _hubConnection.on('UserOffline', (args) {
      final userId = args?[0] as String?;
      if (userId != null) _userOfflineController.add(userId);
    });

    _hubConnection.on('OnlineUsers', (args) {
      final list = (args?[0] as List<dynamic>?)?.cast<String>();
      if (list != null) _onlineUsersController.add(list);
    });

    _hubConnection.on('UserTyping', (args) {
      final senderId = args?[0] as String?;
      if (senderId != null) _typingController.add(senderId);
    });

    _hubConnection.on('UserTypingInGroup', (args) {
      final data = args?[0] as Map<String, dynamic>?;
      if (data != null) _typingGroupController.add(data);
    });

    _hubConnection.on('MessageRead', (args) {
      final readerId = args?[0] as String?;
      if (readerId != null) _messageReadController.add(readerId);
    });
  }

  // Public methods
  Future<void> sendDirectMessage(Map<String, dynamic> dto) =>
      _hubConnection.invoke('SendDirectMessage', args: [dto]);

  Future<void> sendGroupMessage(String groupId, Map<String, dynamic> dto) =>
      _hubConnection.invoke('SendGroupMessage', args: [groupId, dto]);

  Future<void> joinGroup(String groupId) =>
      _hubConnection.invoke('JoinGroup', args: [groupId]);

  Future<void> leaveGroup(String groupId) =>
      _hubConnection.invoke('LeaveGroup', args: [groupId]);

  Future<void> typingDirect(String recipientId) =>
      _hubConnection.invoke('TypingDirect', args: [recipientId]);

  Future<void> typingGroup(String groupId) =>
      _hubConnection.invoke('TypingGroup', args: [groupId]);

  Future<void> markAsRead(String senderId) =>
      _hubConnection.invoke('MarkAsRead', args: [senderId]);

  Future<void> disconnect() async {
    await _hubConnection.stop();
    _connectionStateController.add(HubConnectionState.Disconnected);
  }

  void dispose() {
    _directMessageController.close();
    _groupMessageController.close();
    _userOnlineController.close();
    _userOfflineController.close();
    _onlineUsersController.close();
    _typingController.close();
    _typingGroupController.close();
    _messageReadController.close();
    _connectionStateController.close();
  }

  HubConnectionState? get state => _hubConnection.state;
}