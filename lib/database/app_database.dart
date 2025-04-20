import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// Tabel Users
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username =>
      text().withLength(min: 4, max: 32).unique()(); // ✅ Unik
  TextColumn get password => text()();
  TextColumn get role => text().withDefault(const Constant('kasir'))();
}

// Kelas utama database
@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Ambil semua user
  Future<List<User>> getAllUsers() => select(users).get();

  // Login hanya berdasarkan username dan password
  Future<User?> login(String username, String password) {
    return (select(users)
          ..where((tbl) => tbl.username.equals(username))
          ..where((tbl) => tbl.password.equals(password)))
        .getSingleOrNull();
  }

  // Cek apakah user dengan username tertentu sudah ada
  Future<User?> getUserByUsername(String username) {
    return (select(users)..where((tbl) => tbl.username.equals(username)))
        .getSingleOrNull();
  }

  // Insert user, bisa kamu expand dengan validasi tambahan jika perlu
  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);
}

// Fungsi membuka koneksi database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pms_db.sqlite'));
    return NativeDatabase(file);
  });
}
