import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'database/app_database.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  // Cek apakah sudah ada user
  final users = await db.getAllUsers();
  if (users.isEmpty) {
    await db.insertUser(UsersCompanion(
      username: Value('admin'),
      password: Value('admin123'),
      role: Value('admin'),
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
      title: 'PMS Login',
      home: LoginScreen(db: db),
    );
  }
}
