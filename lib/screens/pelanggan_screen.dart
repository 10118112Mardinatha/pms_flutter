import 'dart:io';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class PelangganScreen extends StatefulWidget {
  final AppDatabase database;

  const PelangganScreen({super.key, required this.database});

  @override
  State<PelangganScreen> createState() => _PelangganScreenState();
}

class _PelangganScreenState extends State<PelangganScreen> {
  late AppDatabase db;
  List<Pelanggan> allPelanggan = [];
  List<Pelanggan> filteredPelanggan = [];
  String searchField = 'Nama';
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final searchOptions = ['Kode', 'Nama', 'Telepon', 'Alamat', 'Kelompok'];

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadPelanggan();
  }

  int _currentPage = 0;

  int get _totalPages => (filteredPelanggan.length / _rowsPerPage)
      .ceil()
      .clamp(1, double.infinity)
      .toInt();

  List<Pelanggan> get _paginatedPelanggan {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (_currentPage + 1) * _rowsPerPage;
    return filteredPelanggan.sublist(
      startIndex,
      endIndex > filteredPelanggan.length ? filteredPelanggan.length : endIndex,
    );
  }

  Future<void> _loadPelanggan() async {
    final data = await db.getAllPelanggans();
    setState(() {
      allPelanggan = data;
      _applySearch();
    });
  }

  Future<void> importPelangganScreensFromExcel({
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
        final kodePelanggan = row[0]?.value.toString() ?? '';
        final namaPelanggan = row[1]?.value.toString() ?? '';
        final usia = row[2]?.value.toString();
        final telepon = row[3]?.value.toString();
        final alamat = row[4]?.value.toString();
        final kelompok = row[5]?.value.toString();

        if (kodePelanggan.isEmpty || namaPelanggan.isEmpty) continue;

        // Cek apakah kodeSupplier sudah ada
        final exists = await (db.select(db.pelanggans)
              ..where((tbl) => tbl.kodPelanggan.equals(kodePelanggan)))
            .getSingleOrNull();

        if (exists != null) {
          debugPrint('Kode $kodePelanggan sudah ada, dilewati.');
          continue;
        }

        await db.into(db.pelanggans).insert(
              PelanggansCompanion(
                kodPelanggan: drift.Value(kodePelanggan),
                namaPelanggan: drift.Value(namaPelanggan),
                usia: drift.Value(int.tryParse(usia.toString())),
                telepon: drift.Value(telepon),
                alamat: drift.Value(alamat),
                kelompok: drift.Value(kelompok),
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
      filteredPelanggan = allPelanggan.where((s) {
        final value = switch (searchField) {
          'Kode' => s.kodPelanggan,
          'Nama' => s.namaPelanggan,
          'Telepon' => s.telepon?.toString() ?? '',
          'Alamat' => s.alamat ?? '',
          'Kelompok' => s.kelompok ?? '',
          _ => '',
        };
        return value.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

//
  void _showForm({Pelanggan? Pelanggan}) {
    final formKey = GlobalKey<FormState>();
    final kodeCtrl = TextEditingController(text: Pelanggan?.kodPelanggan ?? '');
    final namaCtrl =
        TextEditingController(text: Pelanggan?.namaPelanggan ?? '');
    final usiaCtrl =
        TextEditingController(text: Pelanggan?.usia?.toString() ?? '');

    final teleponCtrl =
        TextEditingController(text: Pelanggan?.telepon?.toString() ?? '');

    final alamatCtrl = TextEditingController(text: Pelanggan?.alamat ?? '');
    final kelompokCtrl = TextEditingController(text: Pelanggan?.kelompok ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            PelangganScreen == null ? 'Tambah Pelanggan' : 'Edit Pelanggan'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: kodeCtrl,
                  decoration: InputDecoration(labelText: 'Kode Pelanggan'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Wajib diisi tidak boleh kosong';
                    final exists = allPelanggan.any((s) =>
                        s.kodPelanggan == value &&
                        (Pelanggan == null || s.id != Pelanggan.id));
                    if (exists) return 'Kode sudah digunakan';
                    return null;
                  },
                ),
                TextFormField(
                  controller: namaCtrl,
                  decoration: InputDecoration(labelText: 'Nama '),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Wajib diisi tidak boleh kosong'
                      : null,
                ),
                TextFormField(
                  controller: usiaCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: 'Usia'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Wajib diisi tidak boleh kosong dan berupa angka'
                      : null,
                ),
                TextFormField(
                  controller: teleponCtrl,
                  decoration: InputDecoration(labelText: 'Telepon'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => value == null || value.isEmpty
                      ? 'Wajib diisi tidak boleh kosong dan berupa angka'
                      : null,
                ),
                TextFormField(
                  controller: alamatCtrl,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Wajib diisi tidak boleh kosong'
                      : null,
                ),
                TextFormField(
                  controller: kelompokCtrl,
                  decoration: InputDecoration(labelText: 'Kelompok'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Wajib diisi tidak boleh kosong'
                      : null,
                ),
              ],
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
                if (Pelanggan == null) {
                  await db.insertPelanggans(PelanggansCompanion(
                    kodPelanggan: Value(kodeCtrl.text),
                    namaPelanggan: Value(namaCtrl.text),
                    usia: Value(int.tryParse(usiaCtrl.text)),
                    telepon: Value(teleponCtrl.text),
                    alamat: Value(
                        alamatCtrl.text.isNotEmpty ? alamatCtrl.text : null),
                    kelompok: Value(kelompokCtrl.text.isNotEmpty
                        ? kelompokCtrl.text
                        : null),
                  ));
                } else {
                  await db.updatePelanggans(
                    Pelanggan.copyWith(
                      kodPelanggan: kodeCtrl.text,
                      namaPelanggan: namaCtrl.text,
                      usia: Value(int.tryParse(usiaCtrl.text)),
                      telepon: Value(teleponCtrl.text),
                      alamat: Value(
                          alamatCtrl.text.isNotEmpty ? alamatCtrl.text : null),
                      kelompok: Value(kelompokCtrl.text.isNotEmpty
                          ? kelompokCtrl.text
                          : null),
                    ),
                  );
                }
                if (context.mounted) Navigator.pop(context);
                await _loadPelanggan();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deletePelangganScreen(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Supplier'),
        content: const Text('Yakin ingin menghapus supplier ini?'),
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
      await db.deletePelanggan(id);
      await _loadPelanggan(); // <-- refresh data di layar
    }
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel(); // Ini akan buat sheet default 'Sheet1'

    // Ambil sheet default (langsung Sheet1)
    final String defaultSheet = excel.getDefaultSheet()!;
    final Sheet sheet = excel[defaultSheet];

    // Isi judul kolom
    sheet.appendRow(
        ['No', 'Kode', 'Nama', 'Usia', 'Telepon', 'Alamat', 'Kelompok']);

    // Isi data baris
    for (int i = 0; i < filteredPelanggan.length; i++) {
      var s = filteredPelanggan[i];
      sheet.appendRow([
        s.kodPelanggan,
        s.namaPelanggan,
        s.usia ?? 0,
        s.telepon ?? 0,
        s.alamat ?? '-',
        s.kelompok ?? '-',
      ]);
    }

    // Encode menjadi file
    final fileBytes = excel.encode();
    if (fileBytes != null) {
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
      final fileName = 'tablePelanggan_$formattedDate.xlsx';

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
            headers: ['Kode', 'Nama', 'Usia', 'Telepon', 'Alamat', 'Kelompok'],
            data: filteredPelanggan.map((s) {
              return [
                s.kodPelanggan,
                s.namaPelanggan,
                s.usia?.toString() ?? '',
                s.telepon?.toString() ?? '',
                s.alamat ?? '-',
                s.kelompok ?? '-',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manajemen Pelanggan',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                Row(children: [
                  IconButton(
                    tooltip: 'Print Tabel',
                    icon: const Icon(Icons.print),
                    onPressed: _printTable,
                  ),
                  IconButton(
                    tooltip: 'Import Excel',
                    icon: const Icon(Icons.upload_file),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx'],
                      );
                      if (result != null && result.files.single.path != null) {
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
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              ElevatedButton(
                                child: const Text('Ya, Upload'),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await importPelangganScreensFromExcel(
                              file: file, db: db, onFinished: _loadPelanggan);
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
                    tooltip: 'Export Excel',
                    icon: const Icon(Icons.download),
                    onPressed: _exportToExcel,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton.icon(
                      onPressed: () => _showForm(),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Pelanggan'),
                    ),
                  ),
                ])
              ],
            ),
            const SizedBox(height: 15),
            // === FILTER PENCARIAN ===
            Text(
              'Cari berdasarkan:',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                DropdownButton<String>(
                  value: searchField,
                  onChanged: (value) {
                    setState(() {
                      searchField = value!;
                      _applySearch();
                    });
                  },
                  items: searchOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Cari...',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                searchText = '';
                                _applySearch();
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      searchText = value;
                      _applySearch();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            const Divider(thickness: 1),

            // === HEADER DAFTAR SUPPLIER DAN DROPDOWN BARIS ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📋 Daftar Pelanggan',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blueGrey[900],
                      ),
                ),
                Row(
                  children: [
                    const Text("Tampilkan baris: "),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      items: _rowsPerPageOptions.map((count) {
                        return DropdownMenuItem(
                            value: count, child: Text('$count'));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _rowsPerPage = value!;
                        });
                      },
                    ),
                  ],
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
                    headingRowHeight: 50,
                    columnSpacing: 20,
                    dataTextStyle: const TextStyle(fontSize: 13),
                    columns: const [
                      DataColumn(label: Text('No')), // Kolom Nomor Urut
                      DataColumn(label: Text('Kode')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Usia')),
                      DataColumn(label: Text('Telepon')),
                      DataColumn(label: Text('Alamat')),
                      DataColumn(label: Text('Kelompok')),
                      DataColumn(label: Text('Aksi')), // Aksi
                    ],
                    rows: filteredPelanggan
                        .take(_rowsPerPage)
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final s = entry.value;
                      return DataRow(cells: [
                        DataCell(Text('${index + 1}')), // No
                        DataCell(
                          Tooltip(
                            message: 'Kode Pelanggan',
                            child: Text(s.kodPelanggan),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Nama',
                            child: Text(s.namaPelanggan),
                          ),
                        ),

                        DataCell(
                          Tooltip(
                            message: 'Usia',
                            child: Text(s.usia.toString()),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Telepon',
                            child: Text(s.telepon ?? '0'),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Alamat',
                            child: Text(s.alamat ?? '-'),
                          ),
                        ),

                        DataCell(
                          Tooltip(
                            message: 'Kelompok',
                            child: Text(s.kelompok ?? '-'),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              tooltip: 'Edit Data',
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showForm(Pelanggan: s),
                            ),
                            IconButton(
                              tooltip: 'Hapus Data',
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletePelangganScreen(s.id),
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // === PAGINATION ===
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Halaman ${_currentPage + 1} dari $_totalPages'),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _currentPage > 0
                      ? () => setState(() => _currentPage--)
                      : null,
                  child: const Text('⬅ Prev'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: (_currentPage + 1) < _totalPages
                      ? () => setState(() => _currentPage++)
                      : null,
                  child: const Text('Next ➡'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
