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

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeSupplier => text().withLength(min: 1, max: 20)();
  TextColumn get namaSupplier => text().withLength(min: 1, max: 50)();
  TextColumn get alamat => text().nullable()();
  TextColumn get telepon => text().nullable()();
  TextColumn get keterangan => text().nullable()();
}

// Kelas utama database
@DriftDatabase(tables: [Users, Suppliers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            // Tambahkan migrasi dari versi 1 ke 2
            await m.createTable(suppliers);
          }
          // Tambah logika migrasi lain jika perlu
        },
      );
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

  // SUPPLIER

  Future<List<Supplier>> getAllSuppliers() => select(suppliers).get();

  Future<int> insertSupplier(SuppliersCompanion supplier) {
    return into(suppliers).insert(supplier);
  }

  Future<void> updateSupplier(Supplier supplier) async {
    await update(suppliers).replace(supplier);
  }

  Future<int> deleteSupplier(int id) =>
      (delete(suppliers)..where((tbl) => tbl.id.equals(id))).go();
}

// Fungsi membuka koneksi database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pms_db.sqlite'));
    return NativeDatabase(file);
  });
}
