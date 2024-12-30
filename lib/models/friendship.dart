class Friendship {
  final String id;
  final String requesterId;
  final String recipientId;
  final String status;
  final DateTime createdAt;

  Friendship({
    required this.id,
    required this.requesterId,
    required this.recipientId,
    required this.status,
    required this.createdAt,
  });

  factory Friendship.fromJson(Map<String, dynamic> json) {
    return Friendship(
      id: json['_id'],
      requesterId: json['requester'],
      recipientId: json['recipient'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'requester': requesterId,
      'recipient': recipientId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
