import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/barang_model.dart';

import 'package:pms_flutter/models/rak_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import 'package:printing/printing.dart';
import 'package:collection/collection.dart';

import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

import 'package:file_picker/file_picker.dart';

class BarangScreen extends StatefulWidget {
  final UserModel user;
  const BarangScreen({super.key, required this.user});

  @override
  State<BarangScreen> createState() => _BarangScreenState();
}

class _BarangScreenState extends State<BarangScreen> {
  List<BarangModel> barangs = [];
  List<BarangModel> filteredBarangs = [];
  List<UserModel> users = [];
  String searchField = 'Nama Barang';
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final searchOptions = [
    'Kode Barang',
    'Nama Barang',
    'Kelompok',
    'Rak',
  ];
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    widget.user.id;
    _loadBarangs();
  }

  int _currentPage = 0;

  int get _totalPages => (filteredBarangs.length / _rowsPerPage).ceil();

  List<BarangModel> get _paginatedBarangs {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (_currentPage + 1) * _rowsPerPage;
    final cappedEndIndex =
        endIndex > filteredBarangs.length ? filteredBarangs.length : endIndex;

    return filteredBarangs.sublist(startIndex, cappedEndIndex);
  }

  Future<void> _loadBarangs() async {
    final response = await ApiService.fetchAllBarang();
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      setState(() {
        barangs = jsonList.map((json) => BarangModel.fromJson(json)).toList();

        // Awalnya filteredSuppliers sama dengan semua supplier
        filteredBarangs = List.from(barangs);
        _currentPage = 0; // Reset ke halaman pertama
      });
    } else {
      // Tangani error jika perlu
      print('Gagal memuat data supplier: ${response.statusCode}');
    }
  }

  void _applySearch() {
    setState(() {
      filteredBarangs = barangs.where((s) {
        final value = switch (searchField) {
          'Kode Baramg' => s.kodeBarang,
          'Nama Barang' => s.namaBarang!,
          'Kelompok' => s.kelompok ?? '',
          'Rak' => s.noRak ?? '',
          _ => '',
        };
        return value.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  void _showForm({BarangModel? barang}) {
    final formKey = GlobalKey<FormState>();

    final kodeCtrl =
        TextEditingController(text: barang?.kodeBarang ?? _generateBarang());
    final namaBrgCtrl = TextEditingController(text: barang?.namaBarang ?? '');
    final noRakCtrl = TextEditingController(text: barang?.noRak ?? '');
    final kelompoktCtrl = TextEditingController(text: barang?.kelompok ?? '');
    final satuanCtrl = TextEditingController(text: barang?.satuan ?? '');
    final keteranganctrl =
        TextEditingController(text: barang?.keterangan ?? '');
    final stokCtrl =
        TextEditingController(text: barang?.stokAktual.toString() ?? '');
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final hargaBCtrl = TextEditingController(
      text: barang?.hargaBeli != null
          ? formatCurrency.format(barang!.hargaBeli)
          : '',
    );
    final hargaJCtrl = TextEditingController(
      text: barang?.hargaJual != null
          ? formatCurrency.format(barang!.hargaJual)
          : '',
    );
    final dic1Ctrl = TextEditingController(
      text: barang?.jualDisc1 != null
          ? formatCurrency.format(barang!.jualDisc1)
          : '',
    );
    final dic2Ctrl = TextEditingController(
      text: barang?.jualDisc2 != null
          ? formatCurrency.format(barang!.jualDisc2)
          : '',
    );
    final dic3Ctrl = TextEditingController(
      text: barang?.jualDisc3 != null
          ? formatCurrency.format(barang!.jualDisc3)
          : '',
    );
    final dic4Ctrl = TextEditingController(
      text: barang?.jualDisc4 != null
          ? formatCurrency.format(barang!.jualDisc4)
          : '',
    );

    Future<void> _submitForm() async {
      if (formKey.currentState!.validate()) {
        final kode = kodeCtrl.text;
        final nama = namaBrgCtrl.text;
        final hargaJualInt =
            int.tryParse(hargaJCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                0;
        final disc1 = dic1Ctrl.text.isEmpty
            ? hargaJualInt
            : int.tryParse(dic1Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                hargaJualInt;

        final disc2 = dic2Ctrl.text.isEmpty
            ? hargaJualInt
            : int.tryParse(dic2Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                hargaJualInt;

        final disc3 = dic3Ctrl.text.isEmpty
            ? hargaJualInt
            : int.tryParse(dic3Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                hargaJualInt;

        final disc4 = dic4Ctrl.text.isEmpty
            ? hargaJualInt
            : int.tryParse(dic4Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                hargaJualInt;
        final data = {
          'kodeBarang': kode,
          'namaBarang': nama,
          'noRak': noRakCtrl.text,
          'kelompok': kelompoktCtrl.text,
          'satuan': satuanCtrl.text,
          'stokAktual': int.tryParse(stokCtrl.text) ?? 0,
          'hargaBeli':
              int.tryParse(hargaBCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'hargaJual':
              int.tryParse(hargaJCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'jualDisc1': disc1,
          'jualDisc2': disc2,
          'jualDisc3': disc3,
          'jualDisc4': disc4,
          'keterangan': keteranganctrl.text,
        };

        late http.Response response;

        if (barang == null) {
          // Cek apakah barang dengan kode & nama sama sudah ada secara lokal
          final existing = barangs.firstWhereOrNull(
            (b) =>
                b.kodeBarang == kode &&
                b.namaBarang!.toLowerCase() == nama.toLowerCase(),
          );

          if (existing != null) {
            // Update stok & kirim ke API (PUT)
            final updatedStok =
                existing.stokAktual + (data['stokAktual'] as int);
            data['stokAktual'] = updatedStok;

            response = await ApiService.updateBarang(existing.kodeBarang, data);
            // Log activity untuk update barang
            await ApiService.logActivity(
                widget.user.id, 'Update Barang ${existing.kodeBarang}');
          } else {
            // Barang baru - kirim ke API (POST)
            response = await ApiService.postBarang(data);
            // Log activity untuk tambah barang baru
            await ApiService.logActivity(widget.user.id, 'Tambah Barang $kode');
          }
        } else {
          // Edit barang yang sudah ada
          response = await ApiService.updateBarang(barang.kodeBarang, data);
          // Log activity untuk edit barang
          await ApiService.logActivity(
              widget.user.id, 'Edit Barang ${barang.kodeBarang}');
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) Navigator.pop(context);
          await _loadBarangs(); // refresh data
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
                    onFieldSubmitted: (_) => _submitForm(),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Wajib diisi tidak boleh kosong';
                      final exists = barangs.any((s) =>
                          s.kodeBarang == value &&
                          (barang == null || s.id != barang.id));
                      if (exists) return 'Kode sudah digunakan';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: namaBrgCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Barang'),
                    onFieldSubmitted: (_) => _submitForm(),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                  TypeAheadField<RakModel>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        labelText: 'No Rak',
                      ),
                      controller: noRakCtrl,
                      onSubmitted: (_) => _submitForm(),
                    ),
                    suggestionsCallback: (pattern) async {
                      try {
                        final response = await ApiService.searchRak(pattern);
                        return response
                            .map<RakModel>((json) => RakModel.fromJson(json))
                            .toList();
                      } catch (e) {
                        return [];
                      }
                    },
                    itemBuilder: (context, RakModel suggestion) {
                      return ListTile(
                        title: Text(suggestion.kodeRak),
                        subtitle: Text('Nama: ${suggestion.namaRak}'),
                      );
                    },
                    onSuggestionSelected: (RakModel suggestion) {
                      noRakCtrl.text = suggestion.kodeRak;
                    },
                  ),

                  TextFormField(
                    controller: kelompoktCtrl,
                    decoration: const InputDecoration(labelText: 'Kelompok'),
                    onFieldSubmitted: (_) => _submitForm(),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: satuanCtrl,
                    decoration: const InputDecoration(labelText: 'Satuan'),
                    onFieldSubmitted: (_) => _submitForm(),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: stokCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Stok Aktual'),
                    onFieldSubmitted: (_) => _submitForm(),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong dan hanya angka'
                        : null,
                  ),
                  TextFormField(
                    controller: hargaBCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Harga Beli'),
                    onFieldSubmitted: (_) => _submitForm(),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib diisi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: hargaJCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Harga Jual'),
                    onFieldSubmitted: (_) => _submitForm(),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib diisi tidak boleh kosong';
                      }

                      final hargaJual = int.tryParse(
                              value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0;
                      final hargaBeli = int.tryParse(hargaBCtrl.text
                              .replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0;

                      if (hargaJual < hargaBeli) {
                        return 'Harga Jual tidak boleh lebih kecil dari Harga Beli';
                      }

                      return null;
                    },
                  ),

                  TextFormField(
                    controller: keteranganctrl,
                    decoration: const InputDecoration(labelText: 'Keterangan'),
                    onFieldSubmitted: (_) => _submitForm(),
                  ),

                  // Khusus kalau EDIT, munculkan diskon
                  if (barang != null) ...[
                    TextFormField(
                      controller: dic1Ctrl,
                      decoration: InputDecoration(labelText: 'Disc 1'),
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) => _submitForm(),
                      onChanged: (value) {
                        if (value.isEmpty) return;
                        final number = int.tryParse(
                                value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0;

                        final newText =
                            formatCurrency.format(number).replaceAll(',00', '');
                        dic1Ctrl.value = TextEditingValue(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Harap masukkan angka';

                        // Bersihkan string agar hanya angka
                        final cleanValue =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        final disc = int.tryParse(cleanValue);

                        final hargaJual = int.tryParse(
                          hargaJCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        );
                        final hargaBeli = int.tryParse(
                          hargaBCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        );

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
                      onFieldSubmitted: (_) => _submitForm(),
                      onChanged: (value) {
                        if (value.isEmpty) return;
                        final number = int.tryParse(
                                value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0;

                        final newText =
                            formatCurrency.format(number).replaceAll(',00', '');
                        dic2Ctrl.value = TextEditingValue(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Harap masukkan angka';

                        // Bersihkan string agar hanya angka
                        final cleanValue =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        final disc = int.tryParse(cleanValue);

                        final hargaJual = int.tryParse(
                          hargaJCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        );
                        final hargaBeli = int.tryParse(
                          hargaBCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        );

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
                      onFieldSubmitted: (_) => _submitForm(),
                      onChanged: (value) {
                        if (value.isEmpty) return;
                        final number = int.tryParse(
                                value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0;

                        final newText =
                            formatCurrency.format(number).replaceAll(',00', '');
                        dic3Ctrl.value = TextEditingValue(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Harap masukkan angka';

                        // Bersihkan string agar hanya angka
                        final cleanValue =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        final disc = int.tryParse(cleanValue);

                        final hargaJual = int.tryParse(
                          hargaJCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        );
                        final hargaBeli = int.tryParse(
                          hargaBCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        );

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
                      onFieldSubmitted: (_) => _submitForm(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isEmpty) return;
                        final number = int.tryParse(
                                value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0;

                        final newText =
                            formatCurrency.format(number).replaceAll(',00', '');
                        dic4Ctrl.value = TextEditingValue(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Harap masukkan angka';

                        // Bersihkan string agar hanya angka
                        final cleanValue =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        final disc = int.tryParse(cleanValue);

                        final hargaJual = int.tryParse(
                          hargaJCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        );
                        final hargaBeli = int.tryParse(
                          hargaBCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        );

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
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // warna teks tombol batal
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600, // warna tombol simpan
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
              style: TextStyle(color: Colors.white), // tulisannya putih
            ),
          ),
        ],
      ),
    );
  }

  void _deleteBarang(String kode) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Dokter'),
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
      final response = await ApiService.deleteBarang(kode); // <--- ganti ini

      if (response.statusCode == 200) {
        await ApiService.logActivity(widget.user.id, 'Delete Barang');
        await _loadBarangs(); // refresh data dari server
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

  String _generateBarang() {
    final prefix = 'BRG';
    final existingIds = barangs.map((d) {
      final match = RegExp(r'(\d+)$').firstMatch(d.kodeBarang ?? '');
      return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
    }).toList();

    final maxId = existingIds.isNotEmpty
        ? existingIds.reduce((a, b) => a > b ? a : b)
        : 0;
    final nextId = maxId + 1;
    return '$prefix${nextId.toString().padLeft(3, '0')}';
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel();
    final String defaultSheet = excel.getDefaultSheet()!;
    final Sheet sheet = excel[defaultSheet];

    // Fungsi untuk wrap text panjang ke baris baru
    String wrapTextManual(String? text, {int wrapEvery = 20}) {
      if (text == null || text.isEmpty) return '';
      final buffer = StringBuffer();
      for (int i = 0; i < text.length; i += wrapEvery) {
        final end = (i + wrapEvery < text.length) ? i + wrapEvery : text.length;
        buffer.write(text.substring(i, end));
        if (end < text.length) buffer.write('\n');
      }
      return buffer.toString();
    }

    // Judul kolom
    sheet.appendRow([
      'No',
      'Kode Barang',
      'Nama Barang',
      'Rak',
      'Kelompok',
      'Satuan',
      'Stok Aktual',
      'Harga Beli',
      'Harga Jual',
      'Jual Dic 1',
      'Jual Dic 2',
      'Jual Dic 3',
      'Jual Dic 4',
      'Keterangan',
      "",
    ]);

    // Data isi
    for (int i = 0; i < filteredBarangs.length; i++) {
      var s = filteredBarangs[i];
      sheet.appendRow([
        i + 1,
        s.kodeBarang,
        wrapTextManual(s.namaBarang),
        s.noRak,
        s.kelompok,
        s.satuan,
        s.stokAktual,
        s.hargaBeli,
        s.hargaJual,
        s.jualDisc1,
        s.jualDisc2,
        s.jualDisc3,
        s.jualDisc4,
        wrapTextManual(s.keterangan),
      ]);
    }

    // Encode file
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
              'Rak',
              'Kelompok',
              'Satuan',
              'Stok Aktual',
              'Harga Beli',
              'Harga Jual',
              'Jual Dic 1',
              'Jual Dic 2',
              'Jual Dic 3',
              'Jual Dic 4',
              'Keterangan',
            ],
            data: filteredBarangs.map((s) {
              return [
                s.kodeBarang,
                s.namaBarang,
                s.noRak,
                s.kelompok,
                s.satuan,
                s.stokAktual,
                s.hargaBeli,
                s.hargaJual,
                s.jualDisc1,
                s.jualDisc2,
                s.jualDisc3,
                s.jualDisc4,
                s.keterangan,
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
                              await ApiService.importBarangFromExcel(file);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Import berhasil!')),
                            );
                            await _loadBarangs(); // Refresh tabel
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
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // <- Tambahkan scroll horizontal
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              minWidth: 1300), // Tetap dipertahankan
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
                            sortColumnIndex: 5,
                            columnSpacing: 10,
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
                              DataColumn(label: Text('Harga Disc1')),
                              DataColumn(label: Text('Harga Disc2')),
                              DataColumn(label: Text('Harga Disc3')),
                              DataColumn(label: Text('Harga Disc4')),
                              DataColumn(label: Text('Ketrangan')),
                              DataColumn(label: Text('Aksi')),
                            ],
                            rows:
                                _paginatedBarangs.asMap().entries.map((entry) {
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
                                DataCell(SizedBox(
                                    width: 150,
                                    child: Tooltip(
                                      message: s.namaBarang,
                                      child: Text(
                                        s.namaBarang ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))),
                                DataCell(Tooltip(
                                  message: 'Nomor Rak',
                                  child: Text(s.noRak ?? ''),
                                )),
                                DataCell(Tooltip(
                                  message: 'Kelompok Barang',
                                  child: Text(s.kelompok ?? ''),
                                )),
                                DataCell(Tooltip(
                                  message: 'Satuan',
                                  child: Text(s.satuan ?? ''),
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
                                DataCell(
                                  SizedBox(
                                    width: 150,
                                    child: Tooltip(
                                      message: s.keterangan ?? '',
                                      padding: const EdgeInsets.all(8),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade700,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      preferBelow: true,
                                      child: Text(
                                        s.keterangan ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
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
                                        onPressed: () =>
                                            _deleteBarang(s.kodeBarang),
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
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
