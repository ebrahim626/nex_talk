class GroupSummary {
  final String groupId;
  final String groupName;
  final String? avatarUrl;
  final int memberCount;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  GroupSummary({
    required this.groupId,
    required this.groupName,
    this.avatarUrl,
    required this.memberCount,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  factory GroupSummary.fromJson(Map<String, dynamic> json) {
    return GroupSummary(
      groupId: json['groupId'] as String? ?? '',
      groupName: json['groupName'] as String? ?? 'Unknown group',
      avatarUrl: json['avatarUrl'] as String?,
      memberCount: json['memberCount'] as int? ?? 0,
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageAt: DateTime.tryParse(json['lastMessageAt']?.toString() ?? '') ?? DateTime.now(),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  GroupSummary copyWith({
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return GroupSummary(
      groupId: groupId,
      groupName: groupName,
      avatarUrl: avatarUrl,
      memberCount: memberCount,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}