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

class SupplierScreen extends StatefulWidget {
  final AppDatabase database;

  const SupplierScreen({super.key, required this.database});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  late AppDatabase db;
  List<Supplier> allSuppliers = [];
  List<Supplier> filteredSuppliers = [];
  String searchField = 'Nama';
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final searchOptions = ['Kode', 'Nama', 'Alamat', 'Telepon', 'Keterangan'];

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    final data = await db.getAllSuppliers();
    setState(() {
      allSuppliers = data;
      _applySearch();
    });
  }

  Future<void> importSuppliersFromExcel({
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
        final kodeSupplier = row[0]?.value.toString() ?? '';
        final namaSupplier = row[1]?.value.toString() ?? '';
        final alamat = row[2]?.value.toString();
        final telepon = row[3]?.value.toString();
        final keterangan = row[4]?.value.toString();

        if (kodeSupplier.isEmpty || namaSupplier.isEmpty) continue;

        // Cek apakah kodeSupplier sudah ada
        final exists = await (db.select(db.suppliers)
              ..where((tbl) => tbl.kodeSupplier.equals(kodeSupplier)))
            .getSingleOrNull();

        if (exists != null) {
          debugPrint('Kode $kodeSupplier sudah ada, dilewati.');
          continue;
        }

        await db.into(db.suppliers).insert(
              SuppliersCompanion(
                kodeSupplier: drift.Value(kodeSupplier),
                namaSupplier: drift.Value(namaSupplier),
                alamat: drift.Value(alamat),
                telepon: drift.Value(telepon),
                keterangan: drift.Value(keterangan),
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
      filteredSuppliers = allSuppliers.where((s) {
        final value = switch (searchField) {
          'Kode' => s.kodeSupplier,
          'Nama' => s.namaSupplier,
          'Alamat' => s.alamat ?? '',
          'Telepon' => s.telepon ?? '',
          'Keterangan' => s.keterangan ?? '',
          _ => '',
        };
        return value.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  void _showForm({Supplier? supplier}) {
    final formKey = GlobalKey<FormState>();
    final kodeCtrl = TextEditingController(text: supplier?.kodeSupplier ?? '');
    final namaCtrl = TextEditingController(text: supplier?.namaSupplier ?? '');
    final alamatCtrl = TextEditingController(text: supplier?.alamat ?? '');
    final teleponCtrl = TextEditingController(text: supplier?.telepon ?? '');
    final keteranganCtrl =
        TextEditingController(text: supplier?.keterangan ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(supplier == null ? 'Tambah Supplier' : 'Edit Supplier'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: kodeCtrl,
                  decoration: InputDecoration(labelText: 'Kode Supplier'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Wajib diisi tidak boleh kosong';
                    final exists = allSuppliers.any((s) =>
                        s.kodeSupplier == value &&
                        (supplier == null || s.id != supplier.id));
                    if (exists) return 'Kode sudah digunakan';
                    return null;
                  },
                ),
                TextFormField(
                  controller: namaCtrl,
                  decoration: InputDecoration(labelText: 'Nama Supplier'),
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
                  controller: keteranganCtrl,
                  decoration: InputDecoration(labelText: 'Keterangan'),
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
                if (supplier == null) {
                  await db.insertSupplier(SuppliersCompanion(
                    kodeSupplier: Value(kodeCtrl.text),
                    namaSupplier: Value(namaCtrl.text),
                    alamat: Value(
                        alamatCtrl.text.isNotEmpty ? alamatCtrl.text : null),
                    telepon: Value(
                        teleponCtrl.text.isNotEmpty ? teleponCtrl.text : null),
                    keterangan: Value(keteranganCtrl.text.isNotEmpty
                        ? keteranganCtrl.text
                        : null),
                  ));
                } else {
                  await db.updateSupplier(
                    supplier.copyWith(
                      kodeSupplier: kodeCtrl.text,
                      namaSupplier: namaCtrl.text,
                      alamat: Value(
                          alamatCtrl.text.isNotEmpty ? alamatCtrl.text : null),
                      telepon: Value(teleponCtrl.text.isNotEmpty
                          ? teleponCtrl.text
                          : null),
                      keterangan: Value(keteranganCtrl.text.isNotEmpty
                          ? keteranganCtrl.text
                          : null),
                    ),
                  );
                }
                if (context.mounted) Navigator.pop(context);
                await _loadSuppliers();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteSupplier(int id) async {
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
      await db.deleteSupplier(id);
      await _loadSuppliers(); // <-- refresh data di layar
    }
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel(); // Ini akan buat sheet default 'Sheet1'

    // Ambil sheet default (langsung Sheet1)
    final String defaultSheet = excel.getDefaultSheet()!;
    final Sheet sheet = excel[defaultSheet];

    // Isi judul kolom
    sheet.appendRow(['No', 'Kode', 'Nama', 'Alamat', 'Telepon', 'Keterangan']);

    // Isi data baris
    for (int i = 0; i < filteredSuppliers.length; i++) {
      var s = filteredSuppliers[i];
      sheet.appendRow([
        s.kodeSupplier,
        s.namaSupplier,
        s.alamat ?? '-',
        s.telepon ?? '-',
        s.keterangan ?? '-',
      ]);
    }

    // Encode menjadi file
    final fileBytes = excel.encode();
    if (fileBytes != null) {
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
      final fileName = 'suppliers_$formattedDate.xlsx';

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
            headers: ['Kode', 'Nama', 'Alamat', 'Telepon', 'Keterangan'],
            data: filteredSuppliers.map((s) {
              return [
                s.kodeSupplier,
                s.namaSupplier,
                s.alamat ?? '-',
                s.telepon ?? '-',
                s.keterangan ?? '-',
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
                  'Manajemen Supplier',
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
                          await importSuppliersFromExcel(
                              file: file, db: db, onFinished: _loadSuppliers);
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
                      label: const Text('Tambah Supplier'),
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
                  '📋 Daftar Supplier',
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
                child: SizedBox(
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
                      DataColumn(label: Text('Alamat')),
                      DataColumn(label: Text('Telepon')),
                      DataColumn(label: Text('Keterangan')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: filteredSuppliers
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
                            message: 'Kode Supplier',
                            child: Text(s.kodeSupplier),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Nama Supplier',
                            child: Text(s.namaSupplier),
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
                            message: 'Telepon',
                            child: Text(s.telepon ?? '-'),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Keterengan',
                            child: Text(s.keterangan ?? '-'),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              tooltip: 'Edit Data',
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showForm(supplier: s),
                            ),
                            IconButton(
                              tooltip: 'Hapus Data',
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSupplier(s.id),
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
