import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pms_flutter/models/supplier_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class SupplierScreen extends StatefulWidget {
  final UserModel user;

  const SupplierScreen({super.key, required this.user});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  String searchField = 'Nama';
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final searchOptions = ['Kode', 'Nama', 'Alamat', 'Telepon', 'Keterangan'];
  List<SupplierModel> suppliers = [];
  List<SupplierModel> filteredSuppliers = [];
  @override
  void initState() {
    super.initState();
    widget.user.id;
    _loadSuppliers();
  }

  int _currentPage = 0;

  int get _totalPages => (filteredSuppliers.length / _rowsPerPage).ceil();

  List<SupplierModel> get _paginatedSuppliers {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (_currentPage + 1) * _rowsPerPage;
    final cappedEndIndex = endIndex > filteredSuppliers.length
        ? filteredSuppliers.length
        : endIndex;

    return filteredSuppliers.sublist(startIndex, cappedEndIndex);
  }

  Future<void> _loadSuppliers() async {
    final response = await ApiService.fetchAllSuppliers();
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      setState(() {
        suppliers =
            jsonList.map((json) => SupplierModel.fromJson(json)).toList();

        // Awalnya filteredSuppliers sama dengan semua supplier
        filteredSuppliers = List.from(suppliers);
        _currentPage = 0; // Reset ke halaman pertama
      });
    } else {
      // Tangani error jika perlu
      print('Gagal memuat data supplier: ${response.statusCode}');
    }
  }

  void _applySearch() {
    setState(() {
      filteredSuppliers = suppliers.where((s) {
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

      _currentPage = 0; // Reset ke halaman pertama setelah filter
    });
  }

  void _showForm({SupplierModel? supplier}) {
    final formKey = GlobalKey<FormState>();
    final kodeCtrl = TextEditingController(
        text: supplier?.kodeSupplier ?? _generateKodeSupplier());
    final namaCtrl = TextEditingController(text: supplier?.namaSupplier ?? '');
    final alamatCtrl = TextEditingController(text: supplier?.alamat ?? '');
    final teleponCtrl = TextEditingController(text: supplier?.telepon ?? '');
    final keteranganCtrl =
        TextEditingController(text: supplier?.keterangan ?? '');

    Future<void> simpanData() async {
      if (formKey.currentState!.validate()) {
        final data = {
          'kodeSupplier': kodeCtrl.text,
          'namaSupplier': namaCtrl.text,
          'alamat': alamatCtrl.text,
          'telepon': teleponCtrl.text,
          'keterangan': keteranganCtrl.text,
        };

        late http.Response response;

        if (supplier == null) {
          response = await ApiService.postSupplier(data);
          await ApiService.logActivity(
              widget.user.id, 'Menambah Supplier ${namaCtrl.text}');
        } else {
          response = await ApiService.updateSupplier(
            supplier.kodeSupplier,
            data,
          );
          await ApiService.logActivity(
              widget.user.id, 'Melakukan edit Supplier ${namaCtrl.text}');
        }

        if (response.statusCode == 409) {
          final msg = jsonDecode(response.body)['error'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.red),
          );
          return;
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) Navigator.pop(context);
          await _loadSuppliers(); // refresh data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan data')),
          );
        }
      }
    }

    showDialog(
      context: context,
      builder: (_) => Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                simpanData();
                return null;
              },
            ),
          },
          child: AlertDialog(
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
                        final exists = suppliers.any((s) =>
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
                      onFieldSubmitted: (_) => simpanData(),
                    ),
                  ],
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
                onPressed: simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteSupplier(String kode) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Supplier'),
        content: const Text('Yakin ingin menghapus supplier ini?'),
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
      final response = await ApiService.deleteSupplier(kode); // <--- ganti ini

      if (response.statusCode == 200) {
        await ApiService.logActivity(
            widget.user.id, 'Melakukan delete supplier${kode}');
        await ApiService.logActivity(
            widget.user.id, 'Melakukan delete ${kode}');
        await _loadSuppliers(); // refresh data dari server
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Supplier berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus supplier')),
        );
      }
    }
  }

  String _generateKodeSupplier() {
    final prefix = 'SPL';
    final existingIds = suppliers.map((d) {
      final match = RegExp(r'(\d+)$').firstMatch(d.kodeSupplier ?? '');
      return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
    }).toList();

    final maxId = existingIds.isNotEmpty
        ? existingIds.reduce((a, b) => a > b ? a : b)
        : 0;
    final nextId = maxId + 1;
    return '$prefix${nextId.toString().padLeft(3, '0')}';
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel(); // Buat workbook baru

    final String defaultSheet = excel.getDefaultSheet()!;
    final Sheet sheet = excel[defaultSheet];

    // Header kolom
    sheet.appendRow(['No', 'Kode', 'Nama', 'Alamat', 'Telepon', 'Keterangan']);

    // Data baris
    for (int i = 0; i < filteredSuppliers.length; i++) {
      var s = filteredSuppliers[i];
      sheet.appendRow([
        i + 1, // No urut
        s.kodeSupplier,
        s.namaSupplier,
        s.alamat ?? '-',
        s.telepon ?? '-',
        s.keterangan ?? '-',
      ]);
    }

    // Encode dan share sebagai file
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
            headers: ['No', 'Kode', 'Nama', 'Alamat', 'Telepon', 'Keterangan'],
            data: List.generate(filteredSuppliers.length, (index) {
              final s = filteredSuppliers[index];
              return [
                (index + 1).toString(), // No
                s.kodeSupplier,
                s.namaSupplier,
                s.alamat ?? '-',
                s.telepon ?? '-',
                s.keterangan ?? '-',
              ];
            }),
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
                  '🏬 Manajemen Supplier',
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
                              await ApiService.importSupplierFromExcel(file);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Import berhasil!')),
                            );
                            await _loadSuppliers(); // Refresh tabel
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
                      label: const Text('Tambah Supplier'),
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
                              DataColumn(label: Text('Alamat')),
                              DataColumn(label: Text('Telepon')),
                              DataColumn(label: Text('Keterangan')),
                              DataColumn(label: Text('Aksi')),
                            ],
                            rows: _paginatedSuppliers
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
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () => _showForm(supplier: s),
                                    ),
                                    IconButton(
                                      tooltip: 'Hapus Data',
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _deleteSupplier(s.kodeSupplier),
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
