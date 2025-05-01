import 'dart:io';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PembelianScreen extends StatefulWidget {
  final AppDatabase database;

  const PembelianScreen({super.key, required this.database});

  @override
  State<PembelianScreen> createState() => _PembelianScreenState();
}

class _PembelianScreenState extends State<PembelianScreen> {
  late AppDatabase db;
  List<PembelianstmpData> allPembeliantmp = [];
  List<Pembelians> filteredPembelians = [];
  String searchField = 'Nama';
  String searchText = '';
  Pembelian? data;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nofaktur = TextEditingController();
  final TextEditingController _SupplierController = TextEditingController();
  final TextEditingController _kodeSupplierController = TextEditingController();
  final expiredCtrl = TextEditingController();
  final tanggalBeliCtrl = TextEditingController();
  DateTime? tanggalBeli;
  final TextEditingController totalSeluruhCtrl = TextEditingController();
  String totalpembelian = '';

  Supplier? selectedSupplier;
  DateTime? _selectedDate;
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final searchOptions = ['Kode'];

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadPembelians();
  }

  Future<void> _loadPembelians() async {
    final data = await db.getAllPembeliansTmp();
    setState(() {
      allPembeliantmp = data;
    });
    updateTotalSeluruh();
  }

  Future<void> prosesPembelian() async {
    final noFaktur = _nofaktur.text;
    final kodeSupplier = _kodeSupplierController.text;
    final namaSupplier = _SupplierController.text;
    final tanggal = tanggalBeli;

    if (kodeSupplier.isEmpty ||
        namaSupplier.isEmpty ||
        noFaktur == 0 ||
        tanggal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Faktur, Supplier, dan Tanggal wajib diisi')),
      );
      return;
    }

    final items = await db.getAllPembeliansTmp();

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada data yang akan diproses')),
      );
      return;
    }

    // Gunakan batch untuk insert semua data ke tabel pembelians
    await db.batch((batch) {
      batch.insertAll(
        db.pembelians,
        items
            .map((item) => PembeliansCompanion(
                  noFaktur: Value(noFaktur),
                  kodeSupplier: Value(kodeSupplier),
                  namaSuppliers: Value(namaSupplier),
                  kodeBarang: Value(item.kodeBarang),
                  namaBarang: Value(item.namaBarang),
                  tanggalBeli: Value(tanggal),
                  expired: Value(item.expired),
                  kelompok: Value(item.kelompok),
                  satuan: Value(item.satuan),
                  hargaBeli: Value(item.hargaBeli),
                  hargaJual: Value(item.hargaJual),
                  jualDisc1: Value(item.jualDisc1),
                  jualDisc2: Value(item.jualDisc2),
                  jualDisc3: Value(item.jualDisc3),
                  jualDisc4: Value(item.jualDisc4),
                  ppn: Value(item.ppn),
                  jumlahBeli: Value(item.jumlahBeli),
                  totalHarga: Value(item.totalHarga),
                ))
            .toList(),
      );
      for (final item in items) {
        batch.customStatement(
          '''
        UPDATE barangs
        SET 
          stok_aktual = stok_aktual + ?,
          harga_beli = ?,
          harga_jual = ?,
          jual_disc1 = ?,
          jual_disc2 = ?,
          jual_disc3 = ?,
          jual_disc4 = ?
        WHERE kode_barang = ?
        ''',
          [
            item.jumlahBeli ?? 0,
            item.hargaBeli,
            item.hargaJual,
            item.jualDisc1,
            item.jualDisc2,
            item.jualDisc3,
            item.jualDisc4,
            item.kodeBarang
          ],
        );
      }
    });

    // Bersihkan tabel pembelianstmp
    await db.delete(db.pembelianstmp).go();

    // Reset form input
    _nofaktur.clear();
    _kodeSupplierController.clear();
    _SupplierController.clear();
    tanggalBeli = null;
    tanggalBeliCtrl
        .clear(); // Kalau kamu pakai TextEditingController untuk tanggal
    totalSeluruhCtrl.clear();

    // Refresh tampilan
    _loadPembelians();

    // Notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data pembelian berhasil diproses.')),
    );
  }

  Future<void> prosesbatal() async {
    // Bersihkan tabel pembelianstmp
    await db.delete(db.pembelianstmp).go();

    // Reset form input
    _nofaktur.clear();
    _kodeSupplierController.clear();
    _SupplierController.clear();
    tanggalBeli = null;
    tanggalBeliCtrl.clear();
    totalSeluruhCtrl.clear();
    _loadPembelians();
  }

  Future<void> importDoctorsFromExcel({
    required File file,
    required AppDatabase db,
    required VoidCallback onFinished,
  }) async {
    try {
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables[excel.tables.keys.first];
      if (sheet == null) return;

      for (var row in sheet.rows.skip(1)) {
        final kodeDoctor = row[0]?.value.toString() ?? '';
        final namaDoctor = row[1]?.value.toString() ?? '';
        final alamat = row[2]?.value.toString();
        final telepon = row[3]?.value.toString();
        final nilaipenjualan = row[4]?.value;

        if (kodeDoctor.isEmpty || namaDoctor.isEmpty) continue;

        // Cek apakah kodeSupplier sudah ada
        final exists = await (db.select(db.doctors)
              ..where((tbl) => tbl.kodeDoctor.equals(kodeDoctor)))
            .getSingleOrNull();

        if (exists != null) {
          debugPrint('Kode $kodeDoctor sudah ada, dilewati.');
          continue;
        }

        await db.into(db.doctors).insert(
              DoctorsCompanion(
                kodeDoctor: drift.Value(kodeDoctor),
                namaDoctor: drift.Value(namaDoctor),
                alamat: drift.Value(alamat),
                telepon: drift.Value(telepon),
                nilaipenjualan: drift.Value(nilaipenjualan),
              ),
            );
      }
      onFinished();
    } catch (e) {
      debugPrint('Gagal import file Excel: $e');
    }
  }

//
  Future<void> showFormPembelianstmp({
    PembelianstmpData? data,
  }) async {
    final formKey = GlobalKey<FormState>();

    final kodeBarangCtrl = TextEditingController(text: data?.kodeBarang ?? '');
    final namaBarangCtrl = TextEditingController(text: data?.namaBarang ?? '');
    final expiredCtrl = TextEditingController();
    final kelompokCtrl = TextEditingController(text: data?.kelompok ?? '');
    final satuanCtrl = TextEditingController(text: data?.satuan ?? '');
    final hargaBeliCtrl =
        TextEditingController(text: data?.hargaBeli.toString() ?? '');
    final hargaJualCtrl =
        TextEditingController(text: data?.hargaJual.toString() ?? '');
    final disc1Ctrl =
        TextEditingController(text: data?.jualDisc1?.toString() ?? '');
    final disc2Ctrl =
        TextEditingController(text: data?.jualDisc2?.toString() ?? '');
    final disc3Ctrl =
        TextEditingController(text: data?.jualDisc3?.toString() ?? '');
    final disc4Ctrl =
        TextEditingController(text: data?.jualDisc4?.toString() ?? '');
    final ppnCtrl = TextEditingController(text: data?.ppn?.toString() ?? '');
    final jumlahBeliCtrl =
        TextEditingController(text: data?.jumlahBeli?.toString() ?? '');
    final totalHargaCtrl =
        TextEditingController(text: data?.totalHarga?.toString() ?? '');
    final TextEditingController _barangController = TextEditingController();

    DateTime? expired;
    Barang? selectedBarang;

    void hitungTotalHarga() {
      final harga = int.tryParse(hargaBeliCtrl.text) ?? 0;
      final jumlah = int.tryParse(jumlahBeliCtrl.text) ?? 0;
      final total = harga * jumlah;
      totalHargaCtrl.text = total.toString();
    }

    hargaBeliCtrl.addListener(hitungTotalHarga);
    jumlahBeliCtrl.addListener(hitungTotalHarga);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            Text(data == null ? 'Tambah Pembelian Tmp' : 'Edit Pembelian Tmp'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TypeAheadField<Barang>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        labelText: 'Nama Obat/Jasa',
                      ),
                      controller: _barangController,
                    ),
                    suggestionsCallback: (pattern) async {
                      return await db.searchBarang(
                          pattern); // db adalah instance AppDatabase
                    },
                    itemBuilder: (context, Barang suggestion) {
                      return ListTile(
                        title: Text(suggestion.namaBarang),
                        subtitle: Text('Kode: ${suggestion.kodeBarang}'),
                      );
                    },
                    onSuggestionSelected: (Barang suggestion) {
                      _barangController.text = suggestion.namaBarang;
                      kodeBarangCtrl.text = suggestion.kodeBarang;
                      satuanCtrl.text = suggestion.satuan;
                      kelompokCtrl.text = suggestion.kelompok;
                      // kamu bisa simpan juga id barang atau kodeBarang ke variabel lain
                      selectedBarang = suggestion;
                    },
                  ),
                  Visibility(
                    visible: false,
                    child: TextFormField(
                      controller: kodeBarangCtrl,
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'Kode Barang'),
                    ),
                  ),
                  TextFormField(
                    controller: expiredCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Expired',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      FocusScope.of(context)
                          .requestFocus(FocusNode()); // hilangkan keyboard
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tanggalBeli ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        expired = picked;
                        expiredCtrl.text = picked
                            .toIso8601String()
                            .split('T')
                            .first; // format ke yyyy-MM-dd
                      }
                    },
                  ),
                  Visibility(
                    visible: false,
                    child: TextFormField(
                      controller: kelompokCtrl,
                      decoration: InputDecoration(labelText: 'Kelompok'),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: TextFormField(
                      controller: satuanCtrl,
                      decoration: InputDecoration(labelText: 'Satuan'),
                    ),
                  ),
                  TextFormField(
                    controller: hargaBeliCtrl,
                    decoration: InputDecoration(labelText: 'Harga Beli'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan angka';
                      }
                      // Menggunakan regex untuk memeriksa apakah input hanya angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null; // Valid
                    },
                  ),
                  TextFormField(
                    controller: hargaJualCtrl,
                    decoration: InputDecoration(labelText: 'Harga Jual'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan angka';
                      }
                      // Menggunakan regex untuk memeriksa apakah input hanya angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null; // Valid
                    },
                  ),
                  TextFormField(
                    controller: disc1Ctrl,
                    decoration: InputDecoration(labelText: 'Disc 1'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan angka';
                      }
                      // Menggunakan regex untuk memeriksa apakah input hanya angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null; // Valid
                    },
                  ),
                  TextFormField(
                    controller: disc2Ctrl,
                    decoration: InputDecoration(labelText: 'Disc 2'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan angka';
                      }
                      // Menggunakan regex untuk memeriksa apakah input hanya angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null; // Valid
                    },
                  ),
                  TextFormField(
                    controller: disc3Ctrl,
                    decoration: InputDecoration(labelText: 'Disc 3'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan angka';
                      }
                      // Menggunakan regex untuk memeriksa apakah input hanya angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null; // Valid
                    },
                  ),
                  TextFormField(
                    controller: disc4Ctrl,
                    decoration: InputDecoration(labelText: 'Disc 4'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan angka';
                      }
                      // Menggunakan regex untuk memeriksa apakah input hanya angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null; // Valid
                    },
                  ),
                  TextFormField(
                    controller: ppnCtrl,
                    decoration: InputDecoration(labelText: 'PPN'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan angka';
                      }
                      // Menggunakan regex untuk memeriksa apakah input hanya angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null; // Valid
                    },
                  ),
                  TextFormField(
                    controller: jumlahBeliCtrl,
                    decoration: InputDecoration(labelText: 'Jumlah Beli'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan angka';
                      }
                      // Menggunakan regex untuk memeriksa apakah input hanya angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null; // Valid
                    },
                  ),
                  TextFormField(
                    controller: totalHargaCtrl,
                    decoration: InputDecoration(labelText: 'Total Harga'),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final expiredDate = DateTime.tryParse(expiredCtrl.text);
                if (expiredDate == null) return;

                if (data == null) {
                  await db.insertPembelianTmp(PembelianstmpCompanion(
                    kodeBarang: Value(kodeBarangCtrl.text),
                    namaBarang: Value(_barangController.text),
                    expired: Value(expiredDate),
                    kelompok: Value(kelompokCtrl.text),
                    satuan: Value(satuanCtrl.text),
                    hargaBeli: Value(int.tryParse(hargaBeliCtrl.text) ?? 0),
                    hargaJual: Value(int.tryParse(hargaJualCtrl.text) ?? 0),
                    jualDisc1: Value(int.tryParse(disc1Ctrl.text)),
                    jualDisc2: Value(int.tryParse(disc2Ctrl.text)),
                    jualDisc3: Value(int.tryParse(disc3Ctrl.text)),
                    jualDisc4: Value(int.tryParse(disc4Ctrl.text)),
                    ppn: Value(int.tryParse(ppnCtrl.text)),
                    jumlahBeli: Value(int.tryParse(jumlahBeliCtrl.text)),
                    totalHarga: Value(int.tryParse(totalHargaCtrl.text)),
                  ));
                } else {
                  await db.updatePembelianTmp(
                    data.copyWith(
                      kodeBarang: kodeBarangCtrl.text,
                      namaBarang: namaBarangCtrl.text,
                      expired: expiredDate,
                      kelompok: kelompokCtrl.text,
                      satuan: satuanCtrl.text,
                      hargaBeli: int.tryParse(hargaBeliCtrl.text) ?? 0,
                      hargaJual: int.tryParse(hargaJualCtrl.text) ?? 0,

                      // Mulai dari sini pakai Value karena nullable
                      jualDisc1: Value(int.tryParse(disc1Ctrl.text)),
                      jualDisc2: Value(int.tryParse(disc2Ctrl.text)),
                      jualDisc3: Value(int.tryParse(disc3Ctrl.text)),
                      jualDisc4: Value(int.tryParse(disc4Ctrl.text)),
                      ppn: Value(int.tryParse(ppnCtrl.text)),
                      jumlahBeli: Value(int.tryParse(jumlahBeliCtrl.text)),
                      totalHarga: Value(int.tryParse(totalHargaCtrl.text)),
                    ),
                  );
                }

                if (context.mounted) Navigator.pop(context);
                _loadPembelians();
                updateTotalSeluruh();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> updateTotalSeluruh() async {
    final total = await db.getTotalHargaPembelianTmp();
    totalpembelian = total == 0 ? '' : 'Rp. ${total.toString()}';
  }

  void _deletePembelian(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus'),
        content: const Text('Yakin ingin menghapus ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await db.deletePembelianTmp(id);
      await _loadPembelians(); // <-- refresh data di layar
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pembelian',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                Row(children: [
                  ElevatedButton.icon(
                    onPressed: prosesbatal,
                    icon: const Icon(Icons.close),
                    label: const Text('Batal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .red, // Mengatur warna latar belakang menjadi merah
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  ElevatedButton.icon(
                    onPressed: prosesPembelian,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                  ),
                ])
              ],
            ),

            Divider(thickness: 1),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TextFormField(
                    controller: _nofaktur,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'No Faktur',
                    ),
                  ),
                ),
                SizedBox(width: 250), // Spacing between the text fields
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TypeAheadField<Supplier>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nama Supplier',
                      ),
                      controller: _SupplierController,
                    ),
                    suggestionsCallback: (pattern) async {
                      return await db.searchSupplier(
                          pattern); // db adalah instance AppDatabase
                    },
                    itemBuilder: (context, Supplier suggestion) {
                      return ListTile(
                        title: Text(suggestion.namaSupplier),
                        subtitle: Text('Kode: ${suggestion.kodeSupplier}'),
                      );
                    },
                    onSuggestionSelected: (Supplier suggestion) {
                      _SupplierController.text = suggestion.namaSupplier;
                      _kodeSupplierController.text = suggestion.kodeSupplier;

                      // kamu bisa simpan juga id barang atau kodeBarang ke variabel lain
                      selectedSupplier = suggestion;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TextFormField(
                    controller: tanggalBeliCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Pembelian',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      FocusScope.of(context)
                          .requestFocus(FocusNode()); // hilangkan keyboard
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tanggalBeli ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        tanggalBeli = picked;
                        tanggalBeliCtrl.text = picked
                            .toIso8601String()
                            .split('T')
                            .first; // format ke yyyy-MM-dd
                      }
                    },
                  ),
                ),

                SizedBox(width: 250), // Spacing between the text fields
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TextFormField(
                    controller: _kodeSupplierController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'kode Supplier',
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Total : ${totalpembelian}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(width: 30), // Spacing between the text fields
                ElevatedButton.icon(
                  onPressed: () => showFormPembelianstmp(),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ],
            ),

            const SizedBox(height: 5),
            Divider(
              thickness: 0.5,
            ),
            // === HEADER DAFTAR SUPPLIER DAN DROPDOWN BARIS ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📋 List Barang',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blueGrey[900],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all(Colors.blue.shade100),
                    dataRowColor: MaterialStateProperty.all(Colors.white),
                    border: TableBorder.all(color: Colors.grey.shade300),
                    headingRowHeight: 30,
                    headingTextStyle: const TextStyle(fontSize: 11),
                    columnSpacing: 20,
                    dataTextStyle: const TextStyle(fontSize: 10),
                    columns: const [
                      DataColumn(label: Text('Kode')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Expired')),
                      DataColumn(label: Text('Kelompok')),
                      DataColumn(label: Text('Satuan')),
                      DataColumn(label: Text('Harga Beli')),
                      DataColumn(label: Text('Harga Jual')),
                      DataColumn(label: Text('Disc1')),
                      DataColumn(label: Text('Disc2')),
                      DataColumn(label: Text('Disc3')),
                      DataColumn(label: Text('Disc4')),
                      DataColumn(label: Text('PPN')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: allPembeliantmp.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(Text(p.kodeBarang)),
                          DataCell(Text(p.namaBarang)),
                          DataCell(Text(formatDate(
                              DateTime.parse(p.expired.toString())))),
                          DataCell(Text(p.kelompok)),
                          DataCell(Text(p.satuan)),
                          DataCell(Text(p.hargaBeli.toString())),
                          DataCell(Text(p.hargaJual.toString())),
                          DataCell(Text((p.jualDisc1 ?? 0).toString())),
                          DataCell(Text((p.jualDisc2 ?? 0).toString())),
                          DataCell(Text((p.jualDisc3 ?? 0).toString())),
                          DataCell(Text((p.jualDisc4 ?? 0).toString())),
                          DataCell(Text((p.ppn ?? 0).toString())),
                          DataCell(Text((p.jumlahBeli ?? 0).toString())),
                          DataCell(Text((p.totalHarga ?? 0).toString())),
                          DataCell(Row(
                            children: [
                              IconButton(
                                tooltip: 'Edit Data',
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => showFormPembelianstmp(data: p),
                              ),
                              IconButton(
                                tooltip: 'Hapus Data',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deletePembelian(p.id),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
