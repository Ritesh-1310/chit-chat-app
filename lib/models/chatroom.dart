class Chatroom {
  final String id;
  final String? name; // Nullable
  final bool isGroupChat;
  final List<String> participants;
  final String? createdBy; // Nullable

  Chatroom({
    required this.id,
    this.name, // Nullable
    required this.isGroupChat,
    required this.participants,
    this.createdBy, // Nullable
  });

  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      id: json['_id'],
      name: json['name'], // Can be null
      isGroupChat: json['isGroupChat'],
      participants: List<String>.from(
        json['participants'].map((participant) => participant['_id']),
      ),
      createdBy: json['createdBy'], // Can be null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'isGroupChat': isGroupChat,
      'participants': participants,
      'createdBy': createdBy,
    };
  }
}
