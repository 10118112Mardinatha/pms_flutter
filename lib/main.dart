import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'database/app_database.dart';
import 'screens/login_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1350, 700),
    center: true,
    title:
        "Jl. Temanggung Tilung No.XII, Menteng, Kec. Jekan Raya Kota Palangka Raya Kalimantan Tengah",
    backgroundColor: Colors.white,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setMinimumSize(Size(1350, 700));
    await windowManager.setResizable(false);
  });
  final db = AppDatabase();

  // Cek apakah sudah ada user
  final users = await db.getAllUsers();
  if (users.isEmpty) {
    await db.insertUser(const UsersCompanion(
      username: Value('admin'),
      password: Value('admin123'),
      role: Value('admin'),
      aktif: Value(true),
    ));
  }

  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  const MyApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: LoginScreen(db: db),
    );
  }
}
