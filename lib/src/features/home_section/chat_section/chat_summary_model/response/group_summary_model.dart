class GroupChatModel {
  final String id;
  final String name;
  final int memberCount;
  final DateTime createdAt;

  const GroupChatModel({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.createdAt,
  });

  factory GroupChatModel.fromJson(Map<String, dynamic> json) {
    return GroupChatModel(
      id: json['id'] as String,
      name: json['name'] as String,
      memberCount: json['memberCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'memberCount': memberCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  GroupChatModel copyWith({
    String? id,
    String? name,
    int? memberCount,
    DateTime? createdAt,
  }) {
    return GroupChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}