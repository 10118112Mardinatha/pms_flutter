import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/app_database.dart';
import 'screens/login_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1350, 700),
    center: true,
    title:
        "S.Parman, Kavaleri 29, No. 24, Langkai, Pahandut, Kota Palangka Raya, Kalimantan Tengah, 74874",
    backgroundColor: Colors.white,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setMinimumSize(const Size(1350, 700));
    await windowManager.setResizable(false);
  });

  final db = AppDatabase();
  final users = await db.getAllUsers();

  if (users.isEmpty) {
    await db.insertUser(const UsersCompanion(
      username: Value('admin'),
      password: Value('admin123'),
      role: Value('admin'),
      aktif: Value(true),
    ));
  }

  final int? userId = prefs.getInt('userId');
  final String? username = prefs.getString('username');
  final String? role = prefs.getString('role');
  final bool? aktif = prefs.getBool('aktif');
  final String? avatar = prefs.getString('avatar');

  UserModel? user;
  if (userId != null && username != null && role != null && aktif != null) {
    user = UserModel(
      id: userId,
      username: username,
      password: '', // tidak disimpan
      role: role,
      aktif: aktif,
      avatar: avatar != '' ? avatar : null,
    );
  }

  runApp(MyApp(db: db, user: user));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  final UserModel? user;

  const MyApp({super.key, required this.db, this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apotek Segar',
      home: user != null ? DashboardScreen(user: user!) : const LoginScreen(),
    );
  }
}
