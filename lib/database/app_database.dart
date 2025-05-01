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
  TextColumn get role => text()();
  BoolColumn get aktif => boolean().withDefault(const Constant(true))();
  TextColumn get avatar => text().nullable()();
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
  TextColumn get noRak => text()();
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
  TextColumn get noFaktur => text()();
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
  TextColumn get noFaktur => text()();
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

class Penjualanstmp extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeBarang => text().withLength(min: 1, max: 20)();
  TextColumn get namaBarang => text()();
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
  IntColumn get usia => integer().nullable()();
  IntColumn get telepon => integer().nullable()();
  TextColumn get alamat => text().nullable()();
  TextColumn get kelompok => text().nullable()();
  IntColumn get limitpiutang => integer().nullable()();
  TextColumn get keterangan => text().nullable()();
  IntColumn get jualDiscon => integer().nullable()();
  IntColumn get totalHargaSetelahDisc => integer().nullable()();
  IntColumn get saldoPiutang => integer().nullable()();
}

class Reseps extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get noResep => text().withLength(min: 1, max: 20)();
  DateTimeColumn get tanggal => dateTime()();
  TextColumn get kodePelanggan => text().withLength(min: 1, max: 50)();
  TextColumn get namaPelanggan => text().withLength(min: 1, max: 50)();
  TextColumn get kelompokPelanggan => text().nullable()();
  TextColumn get kodeDoctor => text().nullable()();
  TextColumn get namaDoctor => text().withLength(min: 1, max: 50)();
  IntColumn get usia => integer().nullable()();
  TextColumn get alamat => text().nullable()();
  TextColumn get keterangan => text().nullable()();
  TextColumn get noTelp => text().nullable()();
  TextColumn get kodeBarang => text().withLength(min: 1, max: 20)();
  TextColumn get namaBarang => text()();
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

class Resepstmp extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeBarang => text().withLength(min: 1, max: 20)();
  TextColumn get namaBarang => text()();
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

class Raks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kodeRak => text().withLength(min: 1, max: 20)();
  TextColumn get namaRak => text().withLength(min: 1, max: 50)();
  TextColumn get lokasi => text()();
  TextColumn get keterangan => text().nullable()();
}

// Kelas utama database
@DriftDatabase(tables: [
  Users,
  Suppliers,
  Doctors,
  Barangs,
  Penjualans,
  Penjualanstmp,
  Pembelians,
  Pembelianstmp,
  Pelanggans,
  Reseps,
  Resepstmp,
  Raks,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() {
    return _instance;
  }

  @override
  int get schemaVersion => 1;
  //USERS
  Future<void> deleteUser(int id) async {
    await (delete(users)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> toggleUserActive(int id, bool isActive) async {
    await (update(users)..where((tbl) => tbl.id.equals(id)))
        .write(UsersCompanion(aktif: Value(isActive)));
  }

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

  Future<User?> getUserById(int id) async {
    final result = await (select(users)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return result;
  }

  // Insert user, bisa kamu expand dengan validasi tambahan jika perlu
  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);
  // Metode untuk memverifikasi password berdasarkan userId
  Future<bool> verifyPassword(int userId, String password) async {
    // Mengambil data user berdasarkan userId
    final result = await (select(users)
          ..where((u) => u.id.equals(userId))
          ..limit(1))
        .get();

    if (result.isNotEmpty) {
      // Ambil password yang disimpan
      final storedPassword = result.first.password;
      return storedPassword == password; // Periksa apakah password cocok
    }
    return false;
  }

  Future<void> updateUser(User user) async {
    await update(users).replace(user);
  }

  Future<User?> getLoggedInUser() async {
    return (select(users)..limit(1)).getSingleOrNull();
  }

// Update username
  Future<void> updateUsername(int id, String newUsername) {
    return (update(users)..where((tbl) => tbl.id.equals(id)))
        .write(UsersCompanion(username: Value(newUsername)));
  }

// Update password
  Future<void> updatePassword(int id, String newPassword) {
    return (update(users)..where((tbl) => tbl.id.equals(id)))
        .write(UsersCompanion(password: Value(newPassword)));
  }

  Future<void> updateAvatar(int id, String newAvatarPath) {
    return (update(users)..where((tbl) => tbl.id.equals(id)))
        .write(UsersCompanion(avatar: Value(newAvatarPath)));
  }

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

  Future<List<Doctor>> searcDoctor(String query) {
    return (select(doctors)
          ..where((tbl) =>
              tbl.namaDoctor.like('%$query%') | tbl.kodeDoctor.like('%$query%'))
          ..limit(10))
        .get();
  }

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

  Future<Barang?> getBarangByKode(String kode) {
    return (select(barangs)..where((tbl) => tbl.kodeBarang.equals(kode)))
        .getSingleOrNull();
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

  //penjualanstmp
  Future<List<PenjualanstmpData>> getAllPenjualansTmp() =>
      select(penjualanstmp).get();

  Future<int> insertPenjualanTmp(PenjualanstmpCompanion entry) {
    return into(penjualanstmp).insert(entry);
  }

  Future<bool> updatePenjualanTmp(PenjualanstmpData entry) {
    return update(penjualanstmp).replace(entry);
  }

  Future<int> deletePenjualanTmp(int id) {
    return (delete(penjualanstmp)..where((tbl) => tbl.id.equals(id))).go();
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

  Future<List<Pelanggan>> searchPelanggan(String query) {
    return (select(pelanggans)
          ..where((tbl) =>
              tbl.namaPelanggan.like('%$query%') |
              tbl.kodPelanggan.like('%$query%'))
          ..limit(10))
        .get();
  }

//Reseps

  Future<List<Resep>> getAllReseps() {
    return select(reseps).get();
  }

  Future<int> insertReseps(ResepsCompanion entry) {
    return into(reseps).insert(entry);
  }

  Future<bool> updateResep(Resep entry) {
    return update(reseps).replace(entry);
  }

  Future<int> deleteReseps(int id) {
    return (delete(reseps)..where((tbl) => tbl.id.equals(id))).go();
  }

//pembelian tmp
  Future<List<ResepstmpData>> getAllResepsTmp() {
    return select(resepstmp).get();
  }

  Future<int> insertResepsTmp(ResepstmpCompanion entry) {
    return into(resepstmp).insert(entry);
  }

  Future<bool> updateResepsTmp(ResepstmpData entry) {
    return update(resepstmp).replace(entry);
  }

  Future<int> deleteResepTmp(int id) {
    return (delete(resepstmp)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> getTotalHargaResepTmp() async {
    final result = await customSelect(
      'SELECT SUM(total_harga) as total FROM pembelianstmp',
      readsFrom: {resepstmp},
    ).getSingle();

    return result.data['total'] as int? ?? 0;
  }

  //Rak
  Future<List<Rak>> getAllRaks() => select(raks).get();

  Future<int> insertRaks(RaksCompanion entry) {
    return into(raks).insert(entry);
  }

  Future<bool> updateRaks(Rak entry) {
    return update(raks).replace(entry);
  }

  Future<int> deleteRaks(int id) {
    return (delete(raks)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<Rak>> searcRak(String query) {
    return (select(raks)
          ..where((tbl) => tbl.kodeRak.like('%$query%'))
          ..limit(10))
        .get();
  }
}

// Fungsi membuka koneksi database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pms_db.sqlite'));
    return NativeDatabase(file);
  });
}
