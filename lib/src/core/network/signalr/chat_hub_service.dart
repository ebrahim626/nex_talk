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

  final _conversationUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onConversationUpdate => _conversationUpdateController.stream;

  // Keep track of conversations (you can use a ChangeNotifier or provider)
  List<Map<String, dynamic>> _conversations = [];
  List<Map<String, dynamic>> get conversations => _conversations;

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
        log('[ChatHubService] 🟢 Attempting to connect...');

        _hubConnection = HubConnectionBuilder()
            .withUrl(
          fullUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async {
              final token = await getToken();
              log('[ChatHubService] 🔑 Token retrieved: ${token != null ? "Valid (${token.length} chars)" : "NULL"}');
              return token ?? '';
            },
            transport: HttpTransportType.WebSockets,
          ),
        )
            .withAutomaticReconnect()
            .build();

        _registerListeners();

        _hubConnection.onreconnecting(({error}) {
          log('[ChatHubService] 🔄 Reconnecting... Error: $error');
          _connectionStateController.add(HubConnectionState.Reconnecting);
        });

        _hubConnection.onreconnected(({connectionId}) {
          log('[ChatHubService] ✅ Reconnected! ConnectionId: $connectionId');
          _connectionStateController.add(HubConnectionState.Connected);
        });

        _hubConnection.onclose(({error}) {
          log('[ChatHubService] ❌ Connection closed. Error: $error');
          _connectionStateController.add(HubConnectionState.Disconnected);
        });

        log('[ChatHubService] Starting connection...');
        await _hubConnection.start();
        log('[ChatHubService] ✅ CONNECTION ESTABLISHED SUCCESSFULLY!');
        _connectionStateController.add(HubConnectionState.Connected);

        // Log connection details
        log('[ChatHubService] Connection State: ${_hubConnection.state}');
        log('[ChatHubService] Connection ID: ${_hubConnection.connectionId ?? "N/A"}');

        return;

      } catch (e) {
        log('[ChatHubService] ❌ Connection failed: $e');
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

  void _updateConversationOnNewMessage(Map<String, dynamic> message) {
    final senderId = message['senderId'] as String?;
    final content = message['content'] as String?;
    final timestamp = message['timestamp'] ?? DateTime.now().toIso8601String();

    if (senderId == null || content == null) return;

    // Find existing conversation
    final existingIndex = _conversations.indexWhere(
            (conv) => conv['userId'] == senderId
    );

    if (existingIndex != -1) {
      // Update existing conversation
      _conversations[existingIndex]['lastMessage'] = content;
      _conversations[existingIndex]['lastMessageAt'] = timestamp;
      _conversations[existingIndex]['unreadCount'] =
          (_conversations[existingIndex]['unreadCount'] ?? 0) + 1;
    } else {
      // Add new conversation
      _conversations.add({
        'userId': senderId,
        'username': message['senderName'] ?? 'Unknown',
        'lastMessage': content,
        'lastMessageAt': timestamp,
        'unreadCount': 1,
      });
    }
  }

  void _registerListeners() {
    // ✅ SINGLE listener for ReceiveDirectMessage
    _hubConnection.on('ReceiveDirectMessage', (args) {
      final data = args?[0] as Map<String, dynamic>?;
      if (data != null) {
        log('[ChatHubService] 📨 Received direct message: $data');

        // Add to stream for real-time updates
        _directMessageController.add(data);

        // CRITICAL: Update the conversation list
        _updateConversationOnNewMessage(data);

        // Notify UI about the update
        _conversationUpdateController.add(data);
      }
    });

    _hubConnection.on('ReceiveGroupMessage', (args) {
      final data = args?[0] as Map<String, dynamic>?;
      if (data != null) {
        log('[ChatHubService] 📨 Received group message: $data');
        _groupMessageController.add(data);
        // You might want to update conversations for group messages too
      }
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
    _conversationUpdateController.close();
  }

  HubConnectionState? get state => _hubConnection.state;
}