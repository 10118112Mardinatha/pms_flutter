class UserModel {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? avatar;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'avatar': avatar,
    };
  }
}
