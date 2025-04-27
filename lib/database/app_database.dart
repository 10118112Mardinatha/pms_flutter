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

class Doctors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeDoctor => text().withLength(min: 1, max: 20).unique()();
  TextColumn get namaDoctor => text().withLength(min: 1, max: 50)();
  TextColumn get alamat => text().nullable()();
  TextColumn get telepon => text().nullable()();
  IntColumn get nilaipenjualan => integer().nullable()();
}

class Barangs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeBarang => text().withLength(min: 1, max: 20).unique()();
  TextColumn get namaBarang => text()();
  TextColumn get kelompok => text()();
  TextColumn get satuan => text()();
  IntColumn get stokAktual => integer().withDefault(const Constant(0))();
  IntColumn get hargaBeli => integer().withDefault(const Constant(0))();
  IntColumn get hargaJual => integer().withDefault(const Constant(0))();
  IntColumn get jualDisc1 => integer().nullable()();
  IntColumn get jualDisc2 => integer().nullable()();
  IntColumn get jualDisc3 => integer().nullable()();
  IntColumn get jualDisc4 => integer().nullable()();
}

class Pembelians extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noFaktur => integer().withDefault(const Constant(0))();
  TextColumn get kodeSupplier => text().withLength(min: 1, max: 20)();
  TextColumn get namaSuppliers => text()();
  TextColumn get kodeBarang =>
      text().withLength(min: 1, max: 20)(); // 🔗 relasi
  TextColumn get namaBarang => text()();
  DateTimeColumn get tanggalBeli => dateTime()();
  DateTimeColumn get expired => dateTime()();
  TextColumn get kelompok => text()();
  TextColumn get satuan => text()();
  IntColumn get hargaBeli => integer().withDefault(const Constant(0))();
  IntColumn get hargaJual => integer().withDefault(const Constant(0))();
  IntColumn get jualDisc1 => integer().nullable()();
  IntColumn get jualDisc2 => integer().nullable()();
  IntColumn get jualDisc3 => integer().nullable()();
  IntColumn get jualDisc4 => integer().nullable()();
  IntColumn get ppn => integer().nullable()();
  IntColumn get jumlahBeli => integer().nullable()();
  IntColumn get totalHarga => integer().nullable()();
}

class Pembelianstmp extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeBarang =>
      text().withLength(min: 1, max: 20)(); // 🔗 relasi
  TextColumn get namaBarang => text()();
  DateTimeColumn get expired => dateTime()();
  TextColumn get kelompok => text()();
  TextColumn get satuan => text()();
  IntColumn get hargaBeli => integer().withDefault(const Constant(0))();
  IntColumn get hargaJual => integer().withDefault(const Constant(0))();
  IntColumn get jualDisc1 => integer().nullable()();
  IntColumn get jualDisc2 => integer().nullable()();
  IntColumn get jualDisc3 => integer().nullable()();
  IntColumn get jualDisc4 => integer().nullable()();
  IntColumn get ppn => integer().nullable()();
  IntColumn get jumlahBeli => integer().nullable()();
  IntColumn get totalHarga => integer().nullable()();
}

class Penjualans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noFaktur => integer().withDefault(const Constant(0))();
  TextColumn get kodeBarang =>
      text().withLength(min: 1, max: 20)(); // 🔗 relasi
  TextColumn get namaBarang => text()();
  DateTimeColumn get tanggalBeli => dateTime()();
  DateTimeColumn get expired => dateTime()();
  TextColumn get kelompok => text()();
  TextColumn get satuan => text()();
  IntColumn get hargaBeli => integer().withDefault(const Constant(0))();
  IntColumn get hargaJual => integer().withDefault(const Constant(0))();
  IntColumn get jualDiscon => integer().nullable()();
  IntColumn get jumlahJual => integer().nullable()();
  IntColumn get totalHargaSebelumDisc => integer().nullable()();
  IntColumn get totalHargaSetelahDisc => integer().nullable()();
  IntColumn get totalDisc => integer().nullable()();
}

class Pelanggans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodPelanggan => text().withLength(min: 1, max: 20).unique()();
  TextColumn get namaPelanggan => text().withLength(min: 1, max: 50)();
  TextColumn get alamat => text().nullable()();
  TextColumn get kelompok => text().nullable()();
  IntColumn get limitpiutang => integer().nullable()();
  IntColumn get discount => integer().nullable()();
  IntColumn get totalPenjualan => integer().nullable()();
  IntColumn get saldoPiutang => integer().nullable()();
}

// Kelas utama database
@DriftDatabase(tables: [
  Users,
  Suppliers,
  Doctors,
  Barangs,
  Penjualans,
  Pembelians,
  Pembelianstmp,
  Pelanggans,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() {
    return _instance;
  }

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

  Future<List<Supplier>> searchSupplier(String query) {
    return (select(suppliers)
          ..where((tbl) =>
              tbl.namaSupplier.like('%$query%') |
              tbl.kodeSupplier.like('%$query%'))
          ..limit(10))
        .get();
  }

// DOCTOR
  Future<List<Doctor>> getAllDoctors() => select(doctors).get();

  Future<int> insertDoctors(DoctorsCompanion doctor) {
    return into(doctors).insert(doctor);
  }

  Future<void> updateDoctors(Doctor doctor) async {
    await update(doctors).replace(doctor);
  }

  Future<int> deleteDoctor(int id) =>
      (delete(doctors)..where((tbl) => tbl.id.equals(id))).go();

//Barang
  Future<List<Barang>> getAllBarangs() => select(barangs).get();

  Future<int> insertBarangs(BarangsCompanion barang) {
    return into(barangs).insert(barang);
  }

  Future<void> updateBarangs(Barang barang) async {
    await update(barangs).replace(barang);
  }

  Future<int> deleteBarangs(int id) =>
      (delete(barangs)..where((tbl) => tbl.id.equals(id))).go();

  Future<List<Barang>> searchBarang(String query) {
    return (select(barangs)
          ..where((tbl) =>
              tbl.namaBarang.like('%$query%') | tbl.kodeBarang.like('%$query%'))
          ..limit(10))
        .get();
  }

//penjualan
  Future<List<Penjualan>> getAllPenjualans() => select(penjualans).get();

  Future<int> insertPenjualan(PenjualansCompanion entry) {
    return into(penjualans).insert(entry);
  }

  Future<bool> updatePenjualan(Penjualan entry) {
    return update(penjualans).replace(entry);
  }

  Future<int> deletePenjualan(int id) {
    return (delete(penjualans)..where((tbl) => tbl.id.equals(id))).go();
  }

//pembelian

  Future<List<Pembelian>> getAllPembelians() {
    return select(pembelians).get();
  }

  Future<int> insertPembelian(PembeliansCompanion entry) {
    return into(pembelians).insert(entry);
  }

  Future<bool> updatePembelian(Pembelian entry) {
    return update(pembelians).replace(entry);
  }

  Future<int> deletePembelian(int id) {
    return (delete(pembelians)..where((tbl) => tbl.id.equals(id))).go();
  }

//pembelian tmp
  Future<List<PembelianstmpData>> getAllPembeliansTmp() {
    return select(pembelianstmp).get();
  }

  Future<int> insertPembelianTmp(PembelianstmpCompanion entry) {
    return into(pembelianstmp).insert(entry);
  }

  Future<bool> updatePembelianTmp(PembelianstmpData entry) {
    return update(pembelianstmp).replace(entry);
  }

  Future<int> deletePembelianTmp(int id) {
    return (delete(pembelianstmp)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> getTotalHargaPembelianTmp() async {
    final result = await customSelect(
      'SELECT SUM(total_harga) as total FROM pembelianstmp',
      readsFrom: {pembelianstmp},
    ).getSingle();

    return result.data['total'] as int? ?? 0;
  }

  // PELANGGAN
  Future<List<Pelanggan>> getAllPelanggans() => select(pelanggans).get();
  Future<int> insertPelanggans(PelanggansCompanion pelanggan) {
    return into(pelanggans).insert(pelanggan);
  }

  Future<void> updatePelanggans(Pelanggan pelanggan) async {
    await update(pelanggans).replace(pelanggan);
  }

  Future<int> deletePelanggan(int id) =>
      (delete(pelanggans)..where((tbl) => tbl.id.equals(id))).go();
}

// Fungsi membuka koneksi database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pms_db.sqlite'));
    return NativeDatabase(file);
  });
}
