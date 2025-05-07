import 'dart:io';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class DoctorScreen extends StatefulWidget {
  final AppDatabase database;

  const DoctorScreen({super.key, required this.database});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  late AppDatabase db;
  List<Doctor> allDoctors = [];
  List<Doctor> filteredDoctors = [];
  String searchField = 'Nama';
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final searchOptions = ['Kode', 'Nama', 'Alamat', 'Telepon', 'Penjualan'];

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadDoctors();
  }

  int _currentPage = 0;

  int get _totalPages => (filteredDoctors.length / _rowsPerPage)
      .ceil()
      .clamp(1, double.infinity)
      .toInt();

  List<Doctor> get _paginatedDoctors {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (_currentPage + 1) * _rowsPerPage;
    return filteredDoctors.sublist(
      startIndex,
      endIndex > filteredDoctors.length ? filteredDoctors.length : endIndex,
    );
  }

  Future<void> _loadDoctors() async {
    final data = await db.getAllDoctors();
    setState(() {
      allDoctors = data;
      _applySearch();
    });
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
        final nilaipenjualan = row[4]?.value.toString();

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
                nilaipenjualan:
                    drift.Value(int.tryParse(nilaipenjualan ?? '0') ?? 0),
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
      filteredDoctors = allDoctors.where((s) {
        final value = switch (searchField) {
          'Kode' => s.kodeDoctor,
          'Nama' => s.namaDoctor,
          'Alamat' => s.alamat ?? '',
          'Telepon' => s.telepon ?? '',
          'Penjualan' => s.nilaipenjualan.toString() ?? '',
          _ => '',
        };
        return value.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

//
  void _showForm({Doctor? doctor}) {
    final formKey = GlobalKey<FormState>();
    final kodeCtrl = TextEditingController(text: doctor?.kodeDoctor ?? '');
    final namaCtrl = TextEditingController(text: doctor?.namaDoctor ?? '');
    final alamatCtrl = TextEditingController(text: doctor?.alamat ?? '');
    final teleponCtrl = TextEditingController(text: doctor?.telepon ?? '');
    final nilaipenjualanCtrl =
        TextEditingController(text: doctor?.nilaipenjualan.toString() ?? '');
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(doctor == null ? 'Tambah Dokter' : 'Edit Dokter'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: kodeCtrl,
                  decoration: InputDecoration(labelText: 'Kode Dokter'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Wajib diisi tidak boleh kosong';
                    final exists = allDoctors.any((s) =>
                        s.kodeDoctor == value &&
                        (doctor == null || s.id != doctor.id));
                    if (exists) return 'Kode sudah digunakan';
                    return null;
                  },
                ),
                TextFormField(
                  controller: namaCtrl,
                  decoration: InputDecoration(labelText: 'Nama Doktor'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Wajib diisi tidak boleh kosong'
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
                  controller: teleponCtrl,
                  decoration: InputDecoration(labelText: 'Telepon'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => value == null || value.isEmpty
                      ? 'Wajib diisi tidak boleh kosong dan berupa angka'
                      : null,
                ),
                TextFormField(
                  controller: nilaipenjualanCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: ' Nilai Penjualan'),
                  onChanged: (value) {
                    if (value.isEmpty) return;
                    final number = int.parse(value.replaceAll('.', ''));
                    final newText =
                        formatter.format(number).replaceAll(',00', '');
                    nilaipenjualanCtrl.value = TextEditingValue(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  },
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
                if (doctor == null) {
                  await db.insertDoctors(DoctorsCompanion(
                    kodeDoctor: Value(kodeCtrl.text),
                    namaDoctor: Value(namaCtrl.text),
                    alamat: Value(
                        alamatCtrl.text.isNotEmpty ? alamatCtrl.text : null),
                    telepon: Value(
                        teleponCtrl.text.isNotEmpty ? teleponCtrl.text : null),
                    nilaipenjualan: Value(int.tryParse(nilaipenjualanCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0),
                  ));
                } else {
                  await db.updateDoctors(
                    doctor.copyWith(
                      kodeDoctor: kodeCtrl.text,
                      namaDoctor: namaCtrl.text,
                      alamat: Value(
                          alamatCtrl.text.isNotEmpty ? alamatCtrl.text : null),
                      telepon: Value(teleponCtrl.text.isNotEmpty
                          ? teleponCtrl.text
                          : null),
                      nilaipenjualan: Value(int.tryParse(nilaipenjualanCtrl.text
                              .replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0),
                    ),
                  );
                }
                if (context.mounted) Navigator.pop(context);
                await _loadDoctors();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteDoctor(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Dokter'),
        content: const Text('Yakin ingin menghapus data dokter ini?'),
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
      await db.deleteDoctor(id);
      await _loadDoctors(); // <-- refresh data di layar
    }
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel(); // Ini akan buat sheet default 'Sheet1'

    // Ambil sheet default (langsung Sheet1)
    final String defaultSheet = excel.getDefaultSheet()!;
    final Sheet sheet = excel[defaultSheet];

    // Isi judul kolom
    sheet.appendRow(['No', 'Kode', 'Nama', 'Alamat', 'Telepon', 'Penjualan']);

    // Isi data baris
    for (int i = 0; i < filteredDoctors.length; i++) {
      var s = filteredDoctors[i];
      sheet.appendRow([
        s.kodeDoctor,
        s.namaDoctor,
        s.alamat ?? '-',
        s.telepon ?? '-',
        s.nilaipenjualan ?? '-',
      ]);
    }

    // Encode menjadi file
    final fileBytes = excel.encode();
    if (fileBytes != null) {
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
      final fileName = 'Dokter_$formattedDate.xlsx';

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
            headers: ['Kode', 'Nama', 'Alamat', 'Telepon', 'Penjualan'],
            data: filteredDoctors.map((s) {
              return [
                s.kodeDoctor,
                s.namaDoctor,
                s.alamat ?? '-',
                s.telepon ?? '-',
                s.nilaipenjualan ?? '-',
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
            // === HEADER ATAS ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manajemen Dokter',
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
                          await importDoctorsFromExcel(
                              file: file, db: db, onFinished: _loadDoctors);
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
                      label: const Text('Tambah Dokter'),
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
                      _currentPage = 0; // Reset halaman saat filter berubah
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
                                _currentPage = 0;
                                _applySearch();
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      searchText = value;
                      _currentPage = 0;
                      _applySearch();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(thickness: 1),

            // === HEADER TABEL & DROPDOWN JUMLAH BARIS ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📋 Daftar Dokter',
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
                          _currentPage = 0; // Reset saat jumlah baris diganti
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // === TABEL DOKTER ===
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
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('Kode')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Alamat')),
                      DataColumn(label: Text('Telepon')),
                      DataColumn(label: Text('Penjualan')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: _paginatedDoctors.asMap().entries.map((entry) {
                      final index = entry.key;
                      final s = entry.value;
                      return DataRow(cells: [
                        DataCell(
                            Text('${_currentPage * _rowsPerPage + index + 1}')),
                        DataCell(Text(s.kodeDoctor)),
                        DataCell(Text(s.namaDoctor)),
                        DataCell(Text(s.alamat ?? '-')),
                        DataCell(Text(s.telepon ?? '-')),
                        DataCell(Text(formatter.format(s.nilaipenjualan))),
                        DataCell(Row(
                          children: [
                            IconButton(
                              tooltip: 'Edit Data',
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showForm(doctor: s),
                            ),
                            IconButton(
                              tooltip: 'Hapus Data',
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteDoctor(s.id),
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
