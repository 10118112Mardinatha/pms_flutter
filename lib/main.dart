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
        "Jl. S Parman Ruko Blok II Cav 29, RT 01 RW 07 Kel. Langkai Kec. Pahandut, Kota Palangka Raya, 74874",
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
      avatar: Value('akses'),
    ));
  }

  final int? userId = prefs.getInt('userId');
  final String? username = prefs.getString('username');
  final String? role = prefs.getString('role');
  final bool? aktif = prefs.getBool('aktif');
  final String? avatar = prefs.getString('avatar');

  UserModel? user;
  if (userId != null && username != null && role != null && aktif != null) {
    final allMenus = [
      'dashboard',
      'supplier',
      'dokter',
      'pelanggan',
      'rak',
      'obat',
      'pembelian',
      'penjualan',
      'kasir',
      'resep',
      'laporan_pembelian',
      'laporan_penjualan',
      'laporan_resep',
      'user',
      'log_aktivitas',
      'pesanan',
    ];
    user = UserModel(
      id: userId,
      username: username,
      password: '', // tidak disimpan
      role: role,
      aktif: aktif,
      avatar: avatar != '' ? avatar : null,
      akses: allMenus,
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
