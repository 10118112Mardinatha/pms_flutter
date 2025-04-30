import 'package:pms_flutter/database/app_database.dart';

class UserModel {
  final String id;
  final String username;
  final String role;
  final String? avatar;
  final bool aktif; // Tambahkan ini

  UserModel({
    required this.id,
    required this.username,
    required this.role,
    this.avatar,
    required this.aktif, // Tambahkan ke konstruktor
  });

  // Dari database User
  factory UserModel.fromUser(User user) {
    return UserModel(
      id: user.id.toString(),
      username: user.username,
      role: user.role,
      avatar: user.avatar,
      aktif: user.aktif, // Ambil dari database
    );
  }

  // Dari JSON (kalau ambil dari API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      avatar: json['avatar'],
      aktif: json['aktif'] ?? true, // Default true jika null
    );
  }

  // Untuk kirim ke API atau simpan ke storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'avatar': avatar,
      'aktif': aktif,
    };
  }
}
