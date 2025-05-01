import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:printing/printing.dart';
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

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadBarangs();
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
                    decoration: const InputDecoration(labelText: 'Stok Aktual'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: hargaBCtrl,
                    decoration: const InputDecoration(labelText: 'Harga Beli'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: hargaJCtrl,
                    decoration: const InputDecoration(labelText: 'Harga Jual'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),

                  // Khusus kalau EDIT, munculkan diskon
                  if (barang != null) ...[
                    TextFormField(
                      controller: dic1Ctrl,
                      decoration:
                          const InputDecoration(labelText: 'Jual Disc 1'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Wajib diisi tidak boleh kosong'
                          : null,
                    ),
                    TextFormField(
                      controller: dic2Ctrl,
                      decoration:
                          const InputDecoration(labelText: 'Jual Disc 2'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Wajib diisi tidak boleh kosong'
                          : null,
                    ),
                    TextFormField(
                      controller: dic3Ctrl,
                      decoration:
                          const InputDecoration(labelText: 'Jual Disc 3'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Wajib diisi tidak boleh kosong'
                          : null,
                    ),
                    TextFormField(
                      controller: dic4Ctrl,
                      decoration:
                          const InputDecoration(labelText: 'Jual Disc 4'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Wajib diisi tidak boleh kosong'
                          : null,
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
                  // Tambah Barang
                  await db.insertBarangs(BarangsCompanion(
                    kodeBarang: Value(kodeCtrl.text),
                    namaBarang: Value(namaBrgCtrl.text),
                    noRak: Value(noRakCtrl.text),
                    kelompok: Value(kelompoktCtrl.text),
                    satuan: Value(satuanCtrl.text),
                    stokAktual: Value(int.tryParse(stokCtrl.text) ?? 0),
                    hargaBeli: Value(int.tryParse(hargaBCtrl.text) ?? 0),
                    hargaJual: Value(int.tryParse(hargaJCtrl.text) ?? 0),
                    jualDisc1: const Value(0),
                    jualDisc2: const Value(0),
                    jualDisc3: const Value(0),
                    jualDisc4: const Value(0),
                  ));
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
                      hargaBeli: int.tryParse(hargaBCtrl.text) ?? 0,
                      hargaJual: int.tryParse(hargaJCtrl.text) ?? 0,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manajemen Barang',
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
                    tooltip: 'Export Excel',
                    icon: const Icon(Icons.download),
                    onPressed: _exportToExcel,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton.icon(
                      onPressed: () => _showForm(),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Barang'),
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

            // === HEADER DAFTAR Barang DAN DROPDOWN BARIS ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📋 Daftar Barang',
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
                    headingTextStyle: const TextStyle(fontSize: 11),
                    columnSpacing: 20,
                    dataTextStyle: const TextStyle(fontSize: 13),
                    columns: const [
                      DataColumn(label: Text('No')), // Kolom Nomor Urut
                      DataColumn(label: Text('Kode Barang')),
                      DataColumn(label: Text('Nama Barang')),
                      DataColumn(label: Text('Rak')),
                      DataColumn(label: Text('Kelompok')),
                      DataColumn(label: Text('Satuan')),
                      DataColumn(label: Text('Stok Aktual')),
                      DataColumn(label: Text('Harga Beli')),
                      DataColumn(label: Text('Harga Jual')),
                      DataColumn(label: Text('Jual Dic 1')),
                      DataColumn(label: Text('Jual Dic 2')),
                      DataColumn(label: Text('Jual Dic 3')),
                      DataColumn(label: Text('Jual Dic 4')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: filteredBarangs
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
                            message: 'Kode Barang',
                            child: Text(s.kodeBarang),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Nama Barang',
                            child: Text(s.namaBarang),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Rak',
                            child: Text(s.noRak),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Kelompok',
                            child: Text(s.kelompok),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Satuan',
                            child: Text(s.satuan),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Stok Aktual',
                            child: Text(s.stokAktual.toString()),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Harga Beli',
                            child: Text(s.hargaBeli.toString()),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Harga Jual',
                            child: Text(s.hargaJual.toString()),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Jual Disc 1',
                            child: Text(s.jualDisc1.toString()),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Jual Disc 2',
                            child: Text(s.jualDisc2.toString()),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Jual Disc 3',
                            child: Text(s.jualDisc3.toString()),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: 'Jual Disc 4',
                            child: Text(s.jualDisc4.toString()),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              tooltip: 'Edit Data',
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showForm(barang: s),
                            ),
                            IconButton(
                              tooltip: 'Hapus Data',
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteBarangs(s.id),
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
