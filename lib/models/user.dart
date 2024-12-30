class User {
  final String id;
  final String fullName;
  final String userName;
  final String email;
  final String? profileImageUrl; // Nullable
  final DateTime dob;
  final String gender;
  final String? phoneNumber; // Nullable
  final String status;
  final DateTime lastActive;

  User({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    this.profileImageUrl, // Nullable
    required this.dob,
    required this.gender,
    this.phoneNumber, // Nullable
    required this.status,
    required this.lastActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'], // Handle null
      dob: DateTime.parse(json['dob']),
      gender: json['gender'],
      phoneNumber: json['phoneNumber'], // Handle null
      status: json['status'],
      lastActive: DateTime.parse(json['lastActive']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'dob': dob.toIso8601String(),
      'gender': gender,
      'phoneNumber': phoneNumber,
      'status': status,
      'lastActive': lastActive.toIso8601String(),
    };
  }
}
