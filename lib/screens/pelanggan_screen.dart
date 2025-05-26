import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pms_flutter/models/pelanggan_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import 'package:printing/printing.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class PelangganScreen extends StatefulWidget {
  final UserModel user;

  const PelangganScreen({super.key, required this.user});

  @override
  State<PelangganScreen> createState() => _PelangganScreenState();
}

class _PelangganScreenState extends State<PelangganScreen> {
  late AppDatabase db;
  List<PelangganModel> allPelanggan = [];
  List<PelangganModel> filteredPelanggan = [];
  String searchField = 'Nama';
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final searchOptions = ['Kode', 'Nama', 'Telepon', 'Alamat', 'Kelompok'];

  @override
  void initState() {
    super.initState();
    widget.user.id;
    _loadPelanggan();
  }

  int _currentPage = 0;

  int get _totalPages => (filteredPelanggan.length / _rowsPerPage).ceil();

  List<PelangganModel> get _paginatedpelanggan {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (_currentPage + 1) * _rowsPerPage;
    final cappedEndIndex = endIndex > filteredPelanggan.length
        ? filteredPelanggan.length
        : endIndex;

    return filteredPelanggan.sublist(startIndex, cappedEndIndex);
  }

  Future<void> _loadPelanggan() async {
    final response = await ApiService.fetchAllPelanggan();
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      print(jsonList);
      setState(() {
        allPelanggan =
            jsonList.map((json) => PelangganModel.fromJson(json)).toList();

        // Awalnya filteredSuppliers sama dengan semua supplier
        filteredPelanggan = List.from(allPelanggan);
        _currentPage = 0; // Reset ke halaman pertama
      });
    } else {
      // Tangani error jika perlu
      print('Gagal memuat data supplier: ${response.statusCode}');
    }
  }

  void _applySearch() {
    setState(() {
      filteredPelanggan = allPelanggan.where((s) {
        final value = switch (searchField) {
          'Kode' => s.kodePelanggan,
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

  String _generateKodePelanggan() {
    final prefix = 'PLGN';
    final existingIds = allPelanggan.map((d) {
      final match = RegExp(r'(\d+)$').firstMatch(d.kodePelanggan ?? '');
      return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
    }).toList();

    final maxId = existingIds.isNotEmpty
        ? existingIds.reduce((a, b) => a > b ? a : b)
        : 0;
    final nextId = maxId + 1;
    return '$prefix${nextId.toString().padLeft(3, '0')}';
  }

  void _showForm({PelangganModel? Pelanggan}) {
    final formKey = GlobalKey<FormState>();
    final kodeCtrl = TextEditingController(
        text: Pelanggan?.kodePelanggan ?? _generateKodePelanggan());
    final namaCtrl =
        TextEditingController(text: Pelanggan?.namaPelanggan ?? '');
    final usiaCtrl =
        TextEditingController(text: Pelanggan?.usia?.toString() ?? '');
    final teleponCtrl = TextEditingController(text: Pelanggan?.telepon ?? '');
    final alamatCtrl = TextEditingController(text: Pelanggan?.alamat ?? '');
    final kelompokCtrl = TextEditingController(text: Pelanggan?.kelompok ?? '');

    void submitForm() async {
      if (formKey.currentState!.validate()) {
        final data = {
          'kodePelanggan': kodeCtrl.text,
          'namaPelanggan': namaCtrl.text,
          'telepon': teleponCtrl.text,
          'usia': int.tryParse(usiaCtrl.text) ?? 0,
          'alamat': alamatCtrl.text,
          'kelompok': kelompokCtrl.text
        };

        late http.Response response;
        if (Pelanggan == null) {
          response = await ApiService.postPelanggan(data);
          await ApiService.logActivity(
              widget.user.id, 'Tambah Pelanggan ${namaCtrl.text}');
        } else {
          response = await ApiService.updatePelanggan(
            Pelanggan.kodePelanggan,
            data,
          );
          await ApiService.logActivity(
              widget.user.id, 'Edit Pelanggan ${namaCtrl.text}');
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) Navigator.pop(context);
          await _loadPelanggan();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan data')),
          );
        }
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(Pelanggan == null ? 'Tambah Pelanggan' : 'Edit Pelanggan'),
        content: SizedBox(
          width: 400,
          child: RawKeyboardListener(
            focusNode: FocusNode(), // penting agar bisa terdeteksi
            autofocus: true,
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                submitForm();
              }
            },
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
                          s.kodePelanggan == value &&
                          (Pelanggan == null || s.id != Pelanggan.id));
                      if (exists) return 'Kode sudah digunakan';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: namaCtrl,
                    decoration: InputDecoration(labelText: 'Nama'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: usiaCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: 'Usia'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: teleponCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: 'Telepon'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: alamatCtrl,
                    decoration: InputDecoration(labelText: 'Alamat'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: kelompokCtrl,
                    decoration: InputDecoration(labelText: 'Kelompok'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
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
            onPressed: submitForm,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deletePelanggan(String kode) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Dokter'),
        content: const Text('Yakin ingin menghapus pelanggan ini?'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.close, color: Colors.grey),
            label: const Text('Batal', style: TextStyle(color: Colors.grey)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Hapus', style: TextStyle(color: Colors.red)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final response = await ApiService.deletePelanggan(kode); // <--- ganti ini

      if (response.statusCode == 200) {
        await ApiService.logActivity(
            widget.user.id, 'Delete data pelanggan ${kode}');
        await _loadPelanggan(); // refresh data dari server
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pelanggan berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus pelanggan')),
        );
      }
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
        s.kodePelanggan,
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
                s.kodePelanggan,
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Judul Halaman
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  '🤝 Manajemen Pelanggan',
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

                        if (result == null ||
                            result.files.single.path == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tidak ada file dipilih')),
                          );
                          return;
                        }

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

                        if (confirm != true) return;

                        try {
                          final response =
                              await ApiService.importPelangganFromExcel(file);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Import berhasil!')),
                            );
                            await _loadPelanggan(); // Refresh tabel
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Gagal import: ${response.body}')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Terjadi kesalahan: $e')),
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
                      label: const Text('Tambah Data'),
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
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 1300),
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor:
                                MaterialStateProperty.all(Colors.blue[300]),
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
                              DataColumn(label: Text('No')), // Kolom Nomor Urut
                              DataColumn(label: Text('Kode')),
                              DataColumn(label: Text('Nama')),
                              DataColumn(label: Text('Usia')),
                              DataColumn(label: Text('Telepon')),
                              DataColumn(label: Text('Alamat')),
                              DataColumn(label: Text('Kelompok')),
                              DataColumn(label: Text('Aksi')), // Aksi
                            ],
                            rows: _paginatedpelanggan
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
                                    child: Text(s.kodePelanggan),
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
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () => _showForm(Pelanggan: s),
                                    ),
                                    IconButton(
                                      tooltip: 'Hapus Data',
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _deletePelanggan(s.kodePelanggan),
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
