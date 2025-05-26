import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/doctor_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import 'package:printing/printing.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class DoctorScreen extends StatefulWidget {
  final UserModel user;

  const DoctorScreen({super.key, required this.user});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  late AppDatabase db;
  List<DoctorModel> doctors = [];
  List<DoctorModel> filteredDoctor = [];
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
    widget.user.id;
    _loadDoctors();
  }

  int _currentPage = 0;

  int get _totalPages => (filteredDoctor.length / _rowsPerPage).ceil();

  List<DoctorModel> get _paginatedDoctor {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (_currentPage + 1) * _rowsPerPage;
    final cappedEndIndex =
        endIndex > filteredDoctor.length ? filteredDoctor.length : endIndex;

    return filteredDoctor.sublist(startIndex, cappedEndIndex);
  }

  Future<void> _loadDoctors() async {
    final response = await ApiService.fetchAllDokter();
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      setState(() {
        doctors = jsonList.map((json) => DoctorModel.fromJson(json)).toList();

        // Awalnya filteredSuppliers sama dengan semua supplier
        filteredDoctor = List.from(doctors);
        _currentPage = 0; // Reset ke halaman pertama
      });
    } else {
      // Tangani error jika perlu
      print('Gagal memuat data supplier: ${response.statusCode}');
    }
  }

  void _applySearch() {
    setState(() {
      filteredDoctor = doctors.where((s) {
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
  void _showForm({DoctorModel? doctor}) {
    final formKey = GlobalKey<FormState>();
    final kodeCtrl = TextEditingController(
      text: doctor?.kodeDoctor ?? _generateKodeDokter(),
    );

    final namaCtrl = TextEditingController(text: doctor?.namaDoctor ?? '');
    final alamatCtrl = TextEditingController(text: doctor?.alamat ?? '');
    final teleponCtrl = TextEditingController(text: doctor?.telepon ?? '');

    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    Future<void> _submit() async {
      if (formKey.currentState!.validate()) {
        final data = {
          'kodeDoctor': kodeCtrl.text,
          'namaDoctor': namaCtrl.text,
          'alamat': alamatCtrl.text,
          'telepon': teleponCtrl.text,
        };

        late http.Response response;

        if (doctor == null) {
          response = await ApiService.postDokter(data);
          await ApiService.logActivity(
              widget.user.id, 'Tambah Doctor ${namaCtrl.text}');
        } else {
          response = await ApiService.updateDokter(
            doctor.kodeDoctor,
            data,
          );
          await ApiService.logActivity(
              widget.user.id, 'Edit Doctor ${kodeCtrl.text}');
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) Navigator.pop(context);
          await _loadDoctors();
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
        title: Text(doctor == null ? 'Tambah Dokter' : 'Edit Dokter'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: FocusScope(
              node: FocusScopeNode(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: kodeCtrl,
                    decoration: InputDecoration(labelText: 'Kode Dokter'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib diisi tidak boleh kosong';
                      }
                      final exists = doctors.any((s) =>
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
                    onFieldSubmitted: (_) =>
                        _submit(), // Trigger submit via Enter
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong dan berupa angka'
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 3,
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _generateKodeDokter() {
    final prefix = 'DOC';
    final existingIds = doctors.map((d) {
      final match = RegExp(r'(\d+)$').firstMatch(d.kodeDoctor ?? '');
      return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
    }).toList();

    final maxId = existingIds.isNotEmpty
        ? existingIds.reduce((a, b) => a > b ? a : b)
        : 0;
    final nextId = maxId + 1;
    return '$prefix${nextId.toString().padLeft(3, '0')}';
  }

  void _deleteDokter(String kode) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Dokter'),
        content: const Text('Yakin ingin menghapus Dokter ini?'),
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
      final response = await ApiService.deleteDokter(kode); // <--- ganti ini

      if (response.statusCode == 200) {
        await ApiService.logActivity(widget.user.id, 'Delete Dokter ${kode}');
        await _loadDoctors(); // refresh data dari server
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokter berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus dokter')),
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
    sheet.appendRow(['No', 'Kode', 'Nama', 'Alamat', 'Telepon', 'Penjualan']);

    // Isi data baris
    for (int i = 0; i < filteredDoctor.length; i++) {
      var s = filteredDoctor[i];
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
            data: filteredDoctor.map((s) {
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Judul Halaman
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  '🧑‍⚕️ Manajemen Dokter',
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
                              await ApiService.importDoctorFromExcel(file);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Import berhasil!')),
                            );
                            await _loadDoctors(); // Refresh tabel
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
                      label: const Text('Tambah Dokter'),
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
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Kode')),
                              DataColumn(label: Text('Nama')),
                              DataColumn(label: Text('Alamat')),
                              DataColumn(label: Text('Telepon')),
                              DataColumn(label: Text('Aksi')),
                            ],
                            rows: _paginatedDoctor.asMap().entries.map((entry) {
                              final index = entry.key;
                              final s = entry.value;
                              return DataRow(cells: [
                                DataCell(Tooltip(
                                  message: 'Nomor',
                                  child: Text(
                                      '${_currentPage * _rowsPerPage + index + 1}'),
                                )),
                                DataCell(Tooltip(
                                  message: 'Kode Dokter',
                                  child: Text(s.kodeDoctor),
                                )),
                                DataCell(Tooltip(
                                  message: 'Nama ',
                                  child: Text(s.namaDoctor),
                                )),
                                DataCell(Tooltip(
                                  message: 'Alamat',
                                  child: Text(s.alamat!),
                                )),
                                DataCell(Tooltip(
                                  message: 'Telepon',
                                  child: Text(s.telepon.toString()),
                                )),
                                DataCell(Row(
                                  children: [
                                    Tooltip(
                                      message: 'Edit Data Barang',
                                      child: IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => _showForm(doctor: s),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Hapus Data Barang',
                                      child: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _deleteDokter(s.kodeDoctor),
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
