class UserModel {
  final int id;
  final String username;
  final String? password;
  final String role;
  bool aktif;
  final String? avatar;

  UserModel({
    required this.id,
    required this.username,
    required this.role,
    required this.aktif,
    this.avatar,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        username: json['username'],
        password: json['password'],
        role: json['role'],
        aktif: json['aktif'],
        avatar: json['avatar'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'role': role,
        'aktif': aktif,
        'avatar': avatar,
      };
}
