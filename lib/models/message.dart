class Message {
  final String id;
  final String content;
  final String senderId;
  final String chatroomId;
  final String type;
  final String? mediaUrl;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.chatroomId,
    required this.type,
    this.mediaUrl,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      content: json['content'],
      senderId: json['sender'],
      chatroomId: json['chatroom'],
      type: json['type'],
      mediaUrl: json['mediaUrl'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'sender': senderId,
      'chatroom': chatroomId,
      'type': type,
      'mediaUrl': mediaUrl,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
