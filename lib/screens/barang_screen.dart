import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:collection/collection.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class BarangScreen extends StatefulWidget {
  final AppDatabase database;

  const BarangScreen({super.key, required this.database});

  @override
  State<BarangScreen> createState() => _BarangScreenState();
}

class _BarangScreenState extends State<BarangScreen> {
  late AppDatabase db;
  List<Barang> allBarangs = [];
  List<Barang> filteredBarangs = [];
  String searchField = 'Nama Barang';
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final searchOptions = [
    'Kode Barang',
    'Nama Barang',
    'Kelompok',
    'Satuan',
  ];
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadBarangs();
  }

  int _currentPage = 0;

  int get _totalPages => (filteredBarangs.length / _rowsPerPage)
      .ceil()
      .clamp(1, double.infinity)
      .toInt();

  List<Barang> get _paginatedBarang {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (_currentPage + 1) * _rowsPerPage;
    return filteredBarangs.sublist(
      startIndex,
      endIndex > filteredBarangs.length ? filteredBarangs.length : endIndex,
    );
  }

  Future<void> _loadBarangs() async {
    final data = await db.getAllBarangs();
    setState(() {
      allBarangs = data;
      _applySearch();
    });
  }

  Future<void> importBarangsFromExcel({
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
        final kodeBarang = row[0]?.value.toString() ?? '';
        final namaBarang = row[1]?.value.toString() ?? '';
        final kelompok = row[2]?.value.toString() ?? '';
        final satuan = row[3]?.value.toString() ?? '';
        final stokAktual = row[4]?.value.toString();
        final hargaBeli = row[5]?.value.toString();
        final hargaJual = row[6]?.value.toString();
        final jualDisc1 = row[7]?.value.toString();
        final jualDisc2 = row[8]?.value.toString();
        final jualDisc3 = row[9]?.value.toString();
        final jualDisc4 = row[10]?.value.toString();

        if (kodeBarang.isEmpty || namaBarang.isEmpty) continue;

        // Cek apakah Kode Barang sudah ada
        final exists = await (db.select(db.barangs)
              ..where((tbl) => tbl.kodeBarang.equals(kodeBarang)))
            .getSingleOrNull();

        if (exists != null) {
          debugPrint('Kode $kodeBarang sudah ada, dilewati.');
          continue;
        }

        await db.into(db.barangs).insert(
              BarangsCompanion(
                kodeBarang: drift.Value(kodeBarang),
                namaBarang: drift.Value(namaBarang),
                kelompok: drift.Value(kelompok),
                noRak: drift.Value('0'),
                satuan: drift.Value(satuan),
                stokAktual: drift.Value(int.tryParse(stokAktual ?? '0') ?? 0),
                hargaBeli: drift.Value(int.tryParse(hargaBeli ?? '0') ?? 0),
                hargaJual: drift.Value(int.tryParse(hargaJual ?? '0') ?? 0),
                jualDisc1: drift.Value(int.tryParse(jualDisc1 ?? '0') ?? 0),
                jualDisc2: drift.Value(int.tryParse(jualDisc2 ?? '0') ?? 0),
                jualDisc3: drift.Value(int.tryParse(jualDisc3 ?? '0') ?? 0),
                jualDisc4: drift.Value(int.tryParse(jualDisc4 ?? '0') ?? 0),
              ),
            );
      }
      onFinished();
    } catch (e) {
      debugPrint('Gagal import file Excel: $e');
    }
  }

  void _applySearch() {
    setState(() {
      filteredBarangs = allBarangs.where((s) {
        final value = switch (searchField) {
          'Kode Baramg' => s.kodeBarang,
          'Nama Barang' => s.namaBarang,
          'Kelompok' => s.kelompok ?? '',
          'Satuan' => s.satuan ?? '',
          _ => '',
        };
        return value.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  void _showForm({Barang? barang}) {
    final formKey = GlobalKey<FormState>();
    final kodeCtrl = TextEditingController(text: barang?.kodeBarang ?? '');
    final namaBrgCtrl = TextEditingController(text: barang?.namaBarang ?? '');
    final noRakCtrl = TextEditingController(text: barang?.noRak ?? '');
    final kelompoktCtrl = TextEditingController(text: barang?.kelompok ?? '');
    final satuanCtrl = TextEditingController(text: barang?.satuan ?? '');
    final stokCtrl =
        TextEditingController(text: barang?.stokAktual.toString() ?? '');
    final hargaBCtrl =
        TextEditingController(text: barang?.hargaBeli.toString() ?? '');
    final hargaJCtrl =
        TextEditingController(text: barang?.hargaJual.toString() ?? '');
    final dic1Ctrl =
        TextEditingController(text: barang?.jualDisc1.toString() ?? '');
    final dic2Ctrl =
        TextEditingController(text: barang?.jualDisc2.toString() ?? '');
    final dic3Ctrl =
        TextEditingController(text: barang?.jualDisc3.toString() ?? '');
    final dic4Ctrl =
        TextEditingController(text: barang?.jualDisc4.toString() ?? '');

    final hargaJual = int.tryParse(hargaJCtrl.text) ?? 0;

    final disc1 = int.tryParse(dic1Ctrl.text) ?? hargaJual;
    final disc2 = int.tryParse(dic2Ctrl.text) ?? hargaJual;
    final disc3 = int.tryParse(dic3Ctrl.text) ?? hargaJual;
    final disc4 = int.tryParse(dic4Ctrl.text) ?? hargaJual;

    final formatCurrency =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(barang == null ? 'Tambah Barang' : 'Edit Barang'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Form utama
                  TextFormField(
                    controller: kodeCtrl,
                    decoration: const InputDecoration(labelText: 'Kode Barang'),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Wajib diisi tidak boleh kosong';
                      final exists = allBarangs.any((s) =>
                          s.kodeBarang == value &&
                          (barang == null || s.id != barang.id));
                      if (exists) return 'Kode sudah digunakan';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: namaBrgCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Barang'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                  TypeAheadField<Rak>(
                    textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          labelText: 'No Rak',
                        ),
                        controller: noRakCtrl),
                    suggestionsCallback: (pattern) async {
                      return await db
                          .searcRak(pattern); // db adalah instance AppDatabase
                    },
                    itemBuilder: (context, Rak suggestion) {
                      return ListTile(
                        title: Text(suggestion.kodeRak),
                        subtitle: Text('Kode: ${suggestion.namaRak}'),
                      );
                    },
                    onSuggestionSelected: (Rak suggestion) {
                      noRakCtrl.text = suggestion.kodeRak;
                    },
                  ),
                  TextFormField(
                    controller: kelompoktCtrl,
                    decoration: const InputDecoration(labelText: 'Kelompok'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: satuanCtrl,
                    decoration: const InputDecoration(labelText: 'Satuan'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: stokCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Stok Aktual'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong dan hanya angka'
                        : null,
                  ),
                  TextFormField(
                    controller: hargaBCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: 'Harga Beli'),
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      final number = int.tryParse(
                              value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0;

                      final newText =
                          formatCurrency.format(number).replaceAll(',00', '');
                      hargaBCtrl.value = TextEditingValue(
                        text: newText,
                        selection:
                            TextSelection.collapsed(offset: newText.length),
                      );
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: hargaJCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: 'Harga Jual'),
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      final number = int.tryParse(
                              value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0;

                      final newText =
                          formatCurrency.format(number).replaceAll(',00', '');
                      hargaJCtrl.value = TextEditingValue(
                        text: newText,
                        selection:
                            TextSelection.collapsed(offset: newText.length),
                      );
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),

                  // Khusus kalau EDIT, munculkan diskon
                  if (barang != null) ...[
                    TextFormField(
                      controller: dic1Ctrl,
                      decoration: InputDecoration(labelText: 'Disc 1'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Harap masukkan angka';
                        if (!RegExp(r'^[0-9]+$').hasMatch(value))
                          return 'Hanya angka yang diperbolehkan';

                        final hargaJual = int.tryParse(hargaJCtrl.text);
                        final hargaBeli = int.tryParse(hargaBCtrl.text);
                        final disc = int.tryParse(value);

                        if (hargaBeli == null || hargaJual == null) {
                          return 'Isi harga beli & harga jual terlebih dahulu';
                        }

                        if (disc != null && disc > hargaJual) {
                          return 'Diskon tidak boleh lebih besar dari harga jual';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: dic2Ctrl,
                      decoration: InputDecoration(labelText: 'Disc 2'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Harap masukkan angka';
                        if (!RegExp(r'^[0-9]+$').hasMatch(value))
                          return 'Hanya angka yang diperbolehkan';

                        final hargaJual = int.tryParse(hargaJCtrl.text);
                        final hargaBeli = int.tryParse(hargaBCtrl.text);
                        final disc = int.tryParse(value);

                        if (hargaBeli == null || hargaJual == null) {
                          return 'Isi harga beli & harga jual terlebih dahulu';
                        }

                        if (disc != null && disc > hargaJual) {
                          return 'Diskon tidak boleh lebih besar dari harga jual';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: dic3Ctrl,
                      decoration: InputDecoration(labelText: 'Disc 3'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Harap masukkan angka';
                        if (!RegExp(r'^[0-9]+$').hasMatch(value))
                          return 'Hanya angka yang diperbolehkan';

                        final hargaJual = int.tryParse(hargaJCtrl.text);
                        final hargaBeli = int.tryParse(hargaBCtrl.text);
                        final disc = int.tryParse(value);

                        if (hargaBeli == null || hargaJual == null) {
                          return 'Isi harga beli & harga jual terlebih dahulu';
                        }

                        if (disc != null && disc > hargaJual) {
                          return 'Diskon tidak boleh lebih besar dari harga jual';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: dic4Ctrl,
                      decoration: InputDecoration(labelText: 'Disc 4'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Harap masukkan angka';
                        if (!RegExp(r'^[0-9]+$').hasMatch(value))
                          return 'Hanya angka yang diperbolehkan';

                        final hargaJual = int.tryParse(hargaJCtrl.text);
                        final hargaBeli = int.tryParse(hargaBCtrl.text);
                        final disc = int.tryParse(value);

                        if (hargaBeli == null || hargaJual == null) {
                          return 'Isi harga beli & harga jual terlebih dahulu';
                        }

                        if (disc != null && disc > hargaJual) {
                          return 'Diskon tidak boleh lebih besar dari harga jual';
                        }

                        return null;
                      },
                    ),
                  ],
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
                if (barang == null) {
                  // Cek apakah barang dengan kode & nama sama sudah ada
                  final existing = allBarangs.firstWhereOrNull(
                    (b) =>
                        b.kodeBarang == kodeCtrl.text &&
                        b.namaBarang.toLowerCase() ==
                            namaBrgCtrl.text.toLowerCase(),
                  );

                  if (existing != null) {
                    // Jika barang sudah ada, update stok dan field lain
                    final updatedStok = existing.stokAktual +
                        (int.tryParse(stokCtrl.text) ?? 0);
                    await db.updateBarangs(
                      existing.copyWith(
                        noRak: noRakCtrl.text,
                        kelompok: kelompoktCtrl.text,
                        satuan: satuanCtrl.text,
                        stokAktual: updatedStok,
                        hargaBeli: int.tryParse(hargaBCtrl.text
                                .replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0,
                        hargaJual: int.tryParse(hargaJCtrl.text
                                .replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0,
                      ),
                    );
                  } else {
                    // Tambah Barang Baru
                    await db.insertBarangs(BarangsCompanion(
                      kodeBarang: Value(kodeCtrl.text),
                      namaBarang: Value(namaBrgCtrl.text),
                      noRak: Value(noRakCtrl.text),
                      kelompok: Value(kelompoktCtrl.text),
                      satuan: Value(satuanCtrl.text),
                      stokAktual: Value(int.tryParse(stokCtrl.text) ?? 0),
                      hargaBeli: Value(int.tryParse(hargaBCtrl.text
                              .replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0),
                      hargaJual: Value(int.tryParse(hargaJCtrl.text
                              .replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0),
                      jualDisc1: Value(disc1),
                      jualDisc2: Value(disc2),
                      jualDisc3: Value(disc3),
                      jualDisc4: Value(disc4),
                    ));
                  }
                } else {
                  // Edit Barang
                  await db.updateBarangs(
                    barang.copyWith(
                      kodeBarang: kodeCtrl.text,
                      namaBarang: namaBrgCtrl.text,
                      noRak: noRakCtrl.text,
                      kelompok: kelompoktCtrl.text,
                      satuan: satuanCtrl.text,
                      stokAktual: int.tryParse(stokCtrl.text) ?? 0,
                      hargaBeli: int.tryParse(hargaBCtrl.text
                              .replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0,
                      hargaJual: int.tryParse(hargaJCtrl.text
                              .replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0,
                      jualDisc1: Value(int.tryParse(dic1Ctrl.text) ?? 0),
                      jualDisc2: Value(int.tryParse(dic2Ctrl.text) ?? 0),
                      jualDisc3: Value(int.tryParse(dic3Ctrl.text) ?? 0),
                      jualDisc4: Value(int.tryParse(dic4Ctrl.text) ?? 0),
                    ),
                  );
                }

                if (context.mounted) Navigator.pop(context);
                await _loadBarangs();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteBarangs(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Barang'),
        content: const Text('Yakin ingin menghapus data barang ini?'),
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
      await db.deleteBarangs(id);
      await _loadBarangs(); // <-- refresh data di layar
    }
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel(); // Ini akan buat sheet default 'Sheet1'

    // Ambil sheet default (langsung Sheet1)
    final String defaultSheet = excel.getDefaultSheet()!;
    final Sheet sheet = excel[defaultSheet];

    // Isi judul kolom
    sheet.appendRow([
      'No',
      'Kode Barang',
      'Nama Barang',
      'Kelompok',
      'Satuan',
      'Stok Aktual',
      'Harga Beli',
      'Harga Jual',
      'Jual Dic 1',
      'Jual Dic 2',
      'Jual Dic 3',
      'Jual Dic 4',
    ]);

    // Isi data baris
    for (int i = 0; i < filteredBarangs.length; i++) {
      var s = filteredBarangs[i];
      sheet.appendRow([
        i + 1, // Nomor urut dimulai dari 1
        s.kodeBarang,
        s.namaBarang,
        s.kelompok,
        s.satuan,
        s.stokAktual,
        s.hargaBeli,
        s.hargaJual,
        s.jualDisc1,
        s.jualDisc2,
        s.jualDisc3,
        s.jualDisc4,
      ]);
    }

    // Encode menjadi file
    final fileBytes = excel.encode();
    if (fileBytes != null) {
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
      final fileName = 'Data_Barang_$formattedDate.xlsx';

      await Printing.sharePdf(
        bytes: Uint8List.fromList(fileBytes),
        filename: fileName,
      );
    }
  }

  Future<void> _printTable() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Table.fromTextArray(
            headers: [
              'Kode Barang',
              'Nama Barang',
              'Kelompok',
              'Satuan',
              'Stok Aktual',
              'Harga Beli',
              'Harga Jual',
              'Jual Dic 1',
              'Jual Dic 2',
              'Jual Dic 3',
              'Jual Dic 4'
            ],
            data: filteredBarangs.map((s) {
              return [
                s.kodeBarang,
                s.namaBarang,
                s.kelompok,
                s.satuan,
                s.stokAktual,
                s.hargaBeli,
                s.hargaJual,
                s.jualDisc1,
                s.jualDisc2,
                s.jualDisc3,
                s.jualDisc4,
              ];
            }).toList(),
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Judul Halaman
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  '📦 Manajemen Barang',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dropdown Search Options
                DropdownButton<String>(
                  value: searchField,
                  onChanged: (value) {
                    setState(() {
                      searchField = value!;
                      _applySearch();
                    });
                  },
                  items: searchOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  underline: Container(
                    height: 1,
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  dropdownColor: Colors.white,
                ),

                const SizedBox(width: 12),

                // Fixed Width Search Field
                SizedBox(
                  width: 250,
                  height: 38,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      hintText: 'Cari...',
                      hintStyle: const TextStyle(fontSize: 13),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                searchText = '';
                                _applySearch();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    onChanged: (value) {
                      searchText = value;
                      _applySearch();
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Spacer untuk dorong tombol ke kanan
                const Spacer(),

                // Group tombol kanan
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Import Excel',
                      icon: const Icon(Icons.upload_file),
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['xlsx'],
                        );
                        if (result != null &&
                            result.files.single.path != null) {
                          final file = File(result.files.single.path!);

                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Konfirmasi Import'),
                              content: const Text(
                                  'Apakah Anda yakin ingin mengupload file ini?'),
                              actions: [
                                TextButton(
                                  child: const Text('Batal'),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                  child: const Text('Ya, Upload'),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await importBarangsFromExcel(
                                file: file, db: db, onFinished: _loadBarangs);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Import berhasil!')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tidak ada file dipilih')),
                          );
                        }
                      },
                    ),
                    IconButton(
                      tooltip: 'Export',
                      icon: const Icon(Icons.download),
                      onPressed: _exportToExcel,
                    ),
                    IconButton(
                      tooltip: 'Print',
                      icon: const Icon(Icons.print),
                      onPressed: _printTable,
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showForm(),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Barang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Tabel + pagination
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 1300),
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor:
                                MaterialStateProperty.all(Colors.blue[100]),
                            dataRowColor:
                                MaterialStateProperty.all(Colors.white),
                            border:
                                TableBorder.all(color: Colors.grey.shade300),
                            headingTextStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            dataTextStyle: const TextStyle(fontSize: 13),
                            columnSpacing: 16,
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Kode')),
                              DataColumn(label: Text('Nama')),
                              DataColumn(label: Text('Rak')),
                              DataColumn(label: Text('Kelompok')),
                              DataColumn(label: Text('Satuan')),
                              DataColumn(label: Text('Stok')),
                              DataColumn(label: Text('Beli')),
                              DataColumn(label: Text('Jual')),
                              DataColumn(label: Text('Disc1')),
                              DataColumn(label: Text('Disc2')),
                              DataColumn(label: Text('Disc3')),
                              DataColumn(label: Text('Disc4')),
                              DataColumn(label: Text('Aksi')),
                            ],
                            rows: _paginatedBarang.asMap().entries.map((entry) {
                              final index = entry.key;
                              final s = entry.value;
                              return DataRow(cells: [
                                DataCell(Tooltip(
                                  message: 'Nomor',
                                  child: Text(
                                      '${_currentPage * _rowsPerPage + index + 1}'),
                                )),
                                DataCell(Tooltip(
                                  message: 'Kode Barang',
                                  child: Text(s.kodeBarang),
                                )),
                                DataCell(Tooltip(
                                  message: 'Nama Barang',
                                  child: Text(s.namaBarang),
                                )),
                                DataCell(Tooltip(
                                  message: 'Nomor Rak',
                                  child: Text(s.noRak),
                                )),
                                DataCell(Tooltip(
                                  message: 'Kelompok Barang',
                                  child: Text(s.kelompok),
                                )),
                                DataCell(Tooltip(
                                  message: 'Satuan',
                                  child: Text(s.satuan),
                                )),
                                DataCell(Tooltip(
                                  message: 'Stok Aktual',
                                  child: Text(s.stokAktual.toString()),
                                )),
                                DataCell(Tooltip(
                                  message: 'Harga Beli',
                                  child: Text(formatter.format(s.hargaBeli)),
                                )),
                                DataCell(Tooltip(
                                  message: 'Harga Jual',
                                  child: Text(formatter.format(s.hargaJual)),
                                )),
                                DataCell(Tooltip(
                                  message: 'Diskon 1',
                                  child: Text(formatter.format(s.jualDisc1)),
                                )),
                                DataCell(Tooltip(
                                  message: 'Diskon 2',
                                  child: Text(formatter.format(s.jualDisc2)),
                                )),
                                DataCell(Tooltip(
                                  message: 'Diskon 3',
                                  child: Text(formatter.format(s.jualDisc3)),
                                )),
                                DataCell(Tooltip(
                                  message: 'Diskon 4',
                                  child: Text(formatter.format(s.jualDisc4)),
                                )),
                                DataCell(Row(
                                  children: [
                                    Tooltip(
                                      message: 'Edit Data Barang',
                                      child: IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => _showForm(barang: s),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Hapus Data Barang',
                                      child: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _deleteBarangs(s.id),
                                      ),
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Pagination controls
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Jumlah baris per halaman
                      Row(
                        children: [
                          const Text('Baris per halaman:'),
                          const SizedBox(width: 8),
                          DropdownButton<int>(
                            value: _rowsPerPage,
                            onChanged: (value) {
                              setState(() {
                                _rowsPerPage = value!;
                                _currentPage = 0;
                              });
                            },
                            items: _rowsPerPageOptions
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text('$e'),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),

                      // Info halaman + tombol prev/next
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: _currentPage > 0
                                ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                  }
                                : null,
                          ),
                          Text('Halaman ${_currentPage + 1} dari $_totalPages'),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: _currentPage < _totalPages - 1
                                ? () {
                                    setState(() {
                                      _currentPage++;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
