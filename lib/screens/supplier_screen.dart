import 'dart:io';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Wajib diisi tidak boleh kosong'
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
    var excel = Excel.createExcel();
    final sheet = excel['Suppliers'];
    sheet.appendRow(['Kode', 'Nama', 'Alamat', 'Telepon', 'Keterangan']);
    for (var s in filteredSuppliers) {
      sheet.appendRow([
        s.kodeSupplier,
        s.namaSupplier,
        s.alamat ?? '-',
        s.telepon ?? '-',
        s.keterangan ?? '-',
      ]);
    }
    final fileBytes = excel.encode();
    if (fileBytes != null) {
      await Printing.sharePdf(
          bytes: Uint8List.fromList(fileBytes), filename: 'suppliers.xlsx');
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
      appBar: AppBar(
        title: const Text('Manajemen Supplier'),
        actions: [
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
                    file: file,
                    db: db, // instance database kamu
                    onFinished: _loadSuppliers,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Import berhasil!')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tidak ada file dipilih')),
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
              label: const Text('Tambah'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === FILTER PENCARIAN ===
            Text(
              'Cari berdasarkan:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
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
                  items: searchOptions
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 25),
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

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            // === JUDUL DAN DROPDOWN BARIS ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Supplier',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                ),
                Row(
                  children: [
                    const Text("Tampilkan baris: "),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      items: _rowsPerPageOptions
                          .map((count) => DropdownMenuItem(
                                value: count,
                                child: Text('$count'),
                              ))
                          .toList(),
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

            const SizedBox(height: 10),

            // === TABEL ===
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 800),
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.all(Colors.blue.shade100),
                      dataRowColor: MaterialStateProperty.all(Colors.white),
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columnSpacing: 30,
                      dataRowHeight: 60,
                      headingTextStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      dataTextStyle: const TextStyle(fontSize: 15),
                      columns: const [
                        DataColumn(label: Text('Kode')),
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Alamat')),
                        DataColumn(label: Text('Telepon')),
                        DataColumn(label: Text('Keterangan')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: filteredSuppliers
                          .take(_rowsPerPage)
                          .map((s) => DataRow(cells: [
                                DataCell(Text(s.kodeSupplier)),
                                DataCell(Text(s.namaSupplier)),
                                DataCell(Text(s.alamat ?? '-')),
                                DataCell(Text(s.telepon ?? '-')),
                                DataCell(Text(s.keterangan ?? '-')),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () => _showForm(supplier: s),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _deleteSupplier(s.id),
                                    ),
                                  ],
                                )),
                              ]))
                          .toList(),
                    ),
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
