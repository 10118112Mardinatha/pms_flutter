import 'dart:convert';

class UserModel {
  final int id;
  final String username;
  final String? password;
  final String role;
  bool aktif;
  final String? avatar;
  final List<String> akses;

  UserModel({
    required this.id,
    required this.username,
    required this.role,
    required this.aktif,
    this.avatar,
    required this.password,
    required this.akses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> aksesList = [];
    try {
      final raw = json['akses'];
      if (raw is List) {
        aksesList = List<String>.from(raw);
      } else if (raw is String) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          aksesList = List<String>.from(decoded);
        }
      }
    } catch (_) {
      aksesList = [];
    }

    return UserModel(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      aktif: json['aktif'],
      avatar: json['avatar'],
      akses: aksesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
      'avatar': avatar,
      'aktif': aktif,
      'akses': akses, // List<String> langsung
    };
  }
}
