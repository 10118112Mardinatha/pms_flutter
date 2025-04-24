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

class Doctors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeDoctor => text().withLength(min: 1, max: 20).unique()();
  TextColumn get namaDoctor => text().withLength(min: 1, max: 50)();
  TextColumn get alamat => text().nullable()();
  TextColumn get telepon => text().nullable()();
  IntColumn get nilaipenjualan => integer().nullable()();
}

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeSupplier => text().withLength(min: 1, max: 20)();
  TextColumn get namaSupplier => text().withLength(min: 1, max: 50)();
  TextColumn get alamat => text().nullable()();
  TextColumn get telepon => text().nullable()();
  TextColumn get keterangan => text().nullable()();
}

class Barangs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeBarang => text().withLength(min: 1, max: 20)();
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

class Pembelian extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noFaktur => integer().withDefault(const Constant(0))();
  TextColumn get kodeSupplier => text()
      .withLength(min: 1, max: 20)
      .customConstraint('REFERENCES suppliers(kode_supplier)')();
  TextColumn get namaSuppliers => text()();
  TextColumn get kodeBarang => text()
      .withLength(min: 1, max: 20)
      .customConstraint('REFERENCES barangs(kode_barang)')(); // 🔗 relasi
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

class Penjualan extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noFaktur => integer().withDefault(const Constant(0))();
  TextColumn get kodeBarang =>
      text().customConstraint('REFERENCES barangs(kode_barang)')();
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
  IntColumn get totalHargaSetelahisc => integer().nullable()();
  IntColumn get totalDisc => integer().nullable()();
}

// Kelas utama database
@DriftDatabase(tables: [
  Users,
  Suppliers,
  Doctors,
  Barangs,
  Pembelian,
  Penjualan,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) async {
        await m.createAll();
      }, onUpgrade: (m, from, to) async {
        if (from < 6) {
          await m.createTable(suppliers);
          await m.createTable(doctors);
          await m.createTable(barangs);
          await m.createTable(pembelian);
          await m.createTable(penjualan);
        }
      });

  // USERS
  Future<List<User>> getAllUsers() => select(users).get();
  Future<User?> login(String username, String password) {
    return (select(users)
          ..where((tbl) => tbl.username.equals(username))
          ..where((tbl) => tbl.password.equals(password)))
        .getSingleOrNull();
  }

  Future<User?> getUserByUsername(String username) {
    return (select(users)..where((tbl) => tbl.username.equals(username)))
        .getSingleOrNull();
  }

  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  // SUPPLIERS
  Future<List<Supplier>> getAllSuppliers() => select(suppliers).get();
  Future<int> insertSupplier(SuppliersCompanion supplier) {
    return into(suppliers).insert(supplier);
  }

  Future<Supplier?> getSupplierByKode(String kode) {
    return (select(suppliers)..where((tbl) => tbl.kodeSupplier.equals(kode)))
        .getSingleOrNull();
  }

  Future<void> updateSupplier(Supplier supplier) async {
    await update(suppliers).replace(supplier);
  }

  Future<int> deleteSupplier(int id) =>
      (delete(suppliers)..where((tbl) => tbl.id.equals(id))).go();

  // DOCTORS
  Future<List<Doctor>> getAllDoctors() => select(doctors).get();
  Future<int> insertDoctors(DoctorsCompanion doctor) {
    return into(doctors).insert(doctor);
  }

  Future<void> updateDoctors(Doctor doctor) async {
    await update(doctors).replace(doctor);
  }

  Future<int> deleteDoctor(int id) =>
      (delete(doctors)..where((tbl) => tbl.id.equals(id))).go();

  //Pembelian
  // Tambah pembelian
  Future<int> insertPembelian(PembelianCompanion pembelians) {
    return into(pembelian).insert(pembelians);
  }

// Ambil semua data pembelian
  Future<List<PembelianData>> getAllPembelian() => select(pembelian).get();

// Ambil pembelian berdasarkan kode barang
  Future<List<PembelianData>> getPembelianByKodeBarang(String kodeBarang) {
    return (select(pembelian)
          ..where((tbl) => tbl.kodeBarang.equals(kodeBarang)))
        .get();
  }

// Ambil pembelian berdasarkan kode supplier
  Future<List<PembelianData>> getPembelianByKodeSupplier(String kodeSupplier) {
    return (select(pembelian)
          ..where((tbl) => tbl.kodeSupplier.equals(kodeSupplier)))
        .get();
  }

// Update pembelian
  Future<bool> updatePembelian(PembelianData pembelians) {
    return update(pembelian).replace(pembelians);
  }

// Hapus pembelian
  Future<int> deletePembelian(int id) {
    return (delete(pembelian)..where((tbl) => tbl.id.equals(id))).go();
  }

//*PENJUALAN*
  Future<int> insertPenjualan(PenjualanCompanion penjualans) {
    return into(penjualan).insert(penjualans);
  }

  Future<List<PenjualanData>> getAllPenjualan() {
    return select(penjualan).get();
  }

  Future<List<PenjualanData>> getPenjualanByNoFaktur(int noFaktur) {
    return (select(penjualan)..where((tbl) => tbl.noFaktur.equals(noFaktur)))
        .get();
  }

  Future<List<PenjualanData>> getPenjualanByKodeBarang(String kodeBarang) {
    return (select(penjualan)
          ..where((tbl) => tbl.kodeBarang.equals(kodeBarang)))
        .get();
  }

  Future<List<PenjualanData>> getPenjualanByTanggal(DateTime tanggal) {
    return (select(penjualan)..where((tbl) => tbl.tanggalBeli.equals(tanggal)))
        .get();
  }

  Future<bool> updatePenjualan(PenjualanData penjualans) {
    return update(penjualan).replace(penjualans);
  }

  Future<int> deletePenjualan(int id) {
    return (delete(penjualan)..where((tbl) => tbl.id.equals(id))).go();
  }

  //barang
  Future<List<Barang>> getAllBarangs() => select(barangs).get();

  Future<int> insertBarangs(BarangsCompanion barang) {
    return into(barangs).insert(barang);
  }

  Future<void> updateBarangs(Barang barang) async {
    await update(barangs).replace(barang);
  }

  Future<int> deleteBarangs(int id) =>
      (delete(barangs)..where((tbl) => tbl.id.equals(id))).go();
}

// FUNGSI OPEN DATABASE
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pms_db.sqlite'));
    return NativeDatabase(file);
  });
}
