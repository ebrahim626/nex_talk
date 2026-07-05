class DirectChatModel {
  final String id;
  final String content;
  final DateTime sentAt;
  final bool isRead;
  final String senderId;
  final String senderUsername;
  final String recipientId;
  final String? groupId;

  DirectChatModel({
    required this.id,
    required this.content,
    required this.sentAt,
    required this.isRead,
    required this.senderId,
    required this.senderUsername,
    required this.recipientId,
    this.groupId,
  });

  factory DirectChatModel.fromJson(Map<String, dynamic> json) {
    return DirectChatModel(
      id: json['id'] as String,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      isRead: json['isRead'] as bool,
      senderId: json['senderId'] as String,
      senderUsername: json['senderUsername'] as String,
      recipientId: json['recipientId'] as String,
      groupId: json['groupId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sentAt': sentAt.toIso8601String(),
      'isRead': isRead,
      'senderId': senderId,
      'senderUsername': senderUsername,
      'recipientId': recipientId,
      'groupId': groupId,
    };
  }

  DirectChatModel copyWith({
    String? id,
    String? content,
    DateTime? sentAt,
    bool? isRead,
    String? senderId,
    String? senderUsername,
    String? recipientId,
    String? groupId,
  }) {
    return DirectChatModel(
      id: id ?? this.id,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
      senderId: senderId ?? this.senderId,
      senderUsername: senderUsername ?? this.senderUsername,
      recipientId: recipientId ?? this.recipientId,
      groupId: groupId ?? this.groupId,
    );
  }
}