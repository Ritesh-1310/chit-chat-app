class Group {
  final String id;
  final String name;
  final String? description;
  final List<String> admins;
  final List<String> members;
  final String? profileImageUrl;

  Group({
    required this.id,
    required this.name,
    this.description,
    required this.admins,
    required this.members,
    this.profileImageUrl,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      admins: List<String>.from(json['admins']),
      members: List<String>.from(json['members']),
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'admins': admins,
      'members': members,
      'profileImageUrl': profileImageUrl,
    };
  }
}
