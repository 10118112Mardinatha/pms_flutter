import 'dart:io';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show OrderingMode, OrderingTerm, Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/supplier_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import '../database/app_database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pms_flutter/models/barang_model.dart';
import 'package:pms_flutter/models/pembeliantmp_model.dart';

class PembelianScreen extends StatefulWidget {
  final AppDatabase database;

  const PembelianScreen({super.key, required this.database});

  @override
  State<PembelianScreen> createState() => _PembelianScreenState();
}

class _PembelianScreenState extends State<PembelianScreen> {
  late AppDatabase db;
  List<PembelianTmpModel> allPembeliantmp = [];
  bool _isSelectingSupplier = false;
  String searchField = 'Nama';
  String searchText = '';
  Pembelian? data;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nofaktur = TextEditingController();
  final TextEditingController _SupplierController = TextEditingController();
  final TextEditingController _kodeSupplierController = TextEditingController();
  final expiredCtrl = TextEditingController();
  final tanggalBeliCtrl = TextEditingController();
  DateTime? tanggalBeli = DateTime.now();
  final TextEditingController totalSeluruhCtrl = TextEditingController();
  String totalpembelian = '';
  bool _supplierValid = false;
  Supplier? selectedSupplier;
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final searchOptions = ['Kode'];

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadPembelians();
  }

  Future<void> _loadPembelians() async {
    final data = await ApiService.fetchPembelianTmp('Admin123');
    tanggalBeliCtrl.text = DateTime.now().toIso8601String().split('T').first;

    setState(() {
      allPembeliantmp = data;
    });
    updateTotalSeluruh();
  }

  Future<void> setNofaktur() async {
    try {
      final kode = await ApiService.generatenofakturpembelian();
      setState(() {
        _nofaktur.text = kode;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal generate kode: $e')),
      );
    }
  }

  Future<void> prosesPembelian() async {
    final noFaktur = _nofaktur.text;
    final kodeSupplier = _kodeSupplierController.text;
    final namaSupplier = _SupplierController.text;
    final tanggal = tanggalBeli;

    if (kodeSupplier.isEmpty || noFaktur.isEmpty || tanggal == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Pilih supplier dari daftar dan isi semua data')),
        );
      }
      return;
    }

    final data = {
      'noFaktur': noFaktur,
      'kodeSupplier': kodeSupplier,
      'namaSupplier': namaSupplier,
      'tanggalBeli': tanggal.toIso8601String(),
    };

    try {
      final bolehLanjut = await ApiService.cekNoFakturBelumAda(noFaktur);

      if (!bolehLanjut) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No Faktur sudah digunakan')),
          );
        }
        return;
      }
      late http.Response response;
      response = await ApiService.pindahPembelian(data, 'Admin123');

      if (!mounted) return; // <-- ini cek awal, sebelum lanjut
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pembelian berhasil disimpan')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        await _loadPembelians();
        _nofaktur.clear();
        _kodeSupplierController.clear();
        _SupplierController.clear();
        tanggalBeli = DateTime.now();
        totalSeluruhCtrl.clear();
      } else if (response.statusCode == 404) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.body)),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal menyimpan data. Code: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> prosesbatal() async {
    // Bersihkan tabel pembelianstmp
    late http.Response respon;
    respon = await ApiService.deletePembelianTmpUser('Admin123');
    // Reset form input
    _nofaktur.clear();
    _kodeSupplierController.clear();
    _SupplierController.clear();
    tanggalBeli = null;
    tanggalBeliCtrl.clear();
    totalSeluruhCtrl.clear();
    _loadPembelians();
  }

  Future<void> importPembelianFromExcel({
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
        final kodeBarang = row[0]?.value.toString() ?? ' ';
        final namaBarang = row[1]?.value.toString() ?? '';
        final expired = row[2]?.value.toString() ?? '';
        final kelompok = row[3]?.value.toString() ?? '';
        final satuan = row[4]?.value.toString() ?? '';
        final hargaBeli = row[5]?.value.toString();
        final hargaJual = row[6]?.value.toString();
        final jualDisc1 = row[7]?.value.toString();
        final jualDisc2 = row[8]?.value.toString();
        final jualDisc3 = row[9]?.value.toString();
        final jualDisc4 = row[10]?.value.toString();
        final ppn = row[11]?.value.toString();
        final jumlahpembelian = row[12]?.value.toString();
        final totalhargapembelian = row[13]?.value.toString();

        if (kodeBarang.isEmpty || namaBarang.isEmpty) continue;

        // Cek apakah Kode Barang sudah ada
        final exists = await (db.select(db.pembelianstmp)
              ..where((tbl) => tbl.kodeBarang.equals(kodeBarang)))
            .getSingleOrNull();

        if (exists != null) {
          debugPrint('Kode $kodeBarang sudah ada, dilewati.');
          continue;
        }

        await db.into(db.pembelianstmp).insert(
              PembelianstmpCompanion(
                kodeBarang: drift.Value(kodeBarang),
                namaBarang: drift.Value(namaBarang),
                expired: drift.Value(
                    DateTime.tryParse(expired) ?? DateTime(2000, 1, 1)),
                kelompok: drift.Value(kelompok),
                satuan: drift.Value(satuan),
                hargaBeli: drift.Value(int.tryParse(hargaBeli ?? '0') ?? 0),
                hargaJual: drift.Value(int.tryParse(hargaJual ?? '0') ?? 0),
                jualDisc1: drift.Value(int.tryParse(jualDisc1 ?? '0') ?? 0),
                jualDisc2: drift.Value(int.tryParse(jualDisc2 ?? '0') ?? 0),
                jualDisc3: drift.Value(int.tryParse(jualDisc3 ?? '0') ?? 0),
                jualDisc4: drift.Value(int.tryParse(jualDisc4 ?? '0') ?? 0),
                ppn: drift.Value(int.tryParse(ppn ?? '0') ?? 0),
                jumlahBeli:
                    drift.Value(int.tryParse(jumlahpembelian ?? '0') ?? 0),
                totalHarga:
                    drift.Value(int.tryParse(totalhargapembelian ?? '0') ?? 0),
              ),
            );
      }
      onFinished();
    } catch (e) {
      debugPrint('Gagal import file Excel: $e');
    }
  }

//
  Future<void> showFormPembelianstmp({
    PembelianTmpModel? data,
  }) async {
    final formKey = GlobalKey<FormState>();
    bool _isSelectingSuggestion = false;

    final kodeBarangCtrl = TextEditingController(text: data?.kodeBarang ?? '');
    final kelompokCtrl = TextEditingController(text: data?.kelompok ?? '');
    final satuanCtrl = TextEditingController(text: data?.satuan ?? '');
    final hargaBeliCtrl =
        TextEditingController(text: data?.hargaBeli.toString() ?? '');
    final hargaJualCtrl =
        TextEditingController(text: data?.hargaJual.toString() ?? '');
    final disc1Ctrl =
        TextEditingController(text: data?.jualDisc1?.toString() ?? '');
    final disc2Ctrl =
        TextEditingController(text: data?.jualDisc2?.toString() ?? '');
    final disc3Ctrl =
        TextEditingController(text: data?.jualDisc3?.toString() ?? '');
    final disc4Ctrl =
        TextEditingController(text: data?.jualDisc4?.toString() ?? '');
    final jumlahBeliCtrl =
        TextEditingController(text: data?.jumlahBeli?.toString() ?? '');
    final totalHargaCtrl =
        TextEditingController(text: data?.totalHarga?.toString() ?? '');
    final TextEditingController _barangController =
        TextEditingController(text: data?.namaBarang ?? '');
    final formatCurrency =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    Barang? selectedBarang;

    void hitungTotalHarga() {
      final harga =
          int.tryParse(hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0;
      final jumlah =
          int.tryParse(jumlahBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0;
      final total = harga * jumlah;
      final formatter = NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      totalHargaCtrl.text = formatter.format(total);
    }

    hargaBeliCtrl.addListener(hitungTotalHarga);
    jumlahBeliCtrl.addListener(hitungTotalHarga);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(data == null ? 'Tambah kepembelian' : 'Edit Pembelian'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TypeAheadField<BarangModel>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        labelText: 'Nama Obat/Jasa',
                      ),
                      controller: _barangController,
                      onChanged: (value) {
                        if (!_isSelectingSuggestion) {
                          // Kosongkan field jika user sedang mengetik (bukan dari suggestion)
                          kodeBarangCtrl.clear();
                          satuanCtrl.clear();
                          kelompokCtrl.clear();
                          hargaJualCtrl.clear();
                          hargaBeliCtrl.clear();
                          disc1Ctrl.clear();
                          disc2Ctrl.clear();
                          disc3Ctrl.clear();
                          disc4Ctrl.clear();
                        }
                      },
                    ),
                    suggestionsCallback: (pattern) async {
                      try {
                        final response = await ApiService.searchBarang(pattern);
                        return response
                            .map<BarangModel>(
                                (json) => BarangModel.fromJson(json))
                            .toList();
                      } catch (e) {
                        return [];
                      } // db adalah instance AppDatabase
                    },
                    itemBuilder: (context, BarangModel suggestion) {
                      return ListTile(
                        title: Text(suggestion.namaBarang!),
                        subtitle: Text(
                            'Kode: ${suggestion.kodeBarang}|| Rak : ${suggestion.noRak}'),
                      );
                    },
                    onSuggestionSelected: (BarangModel suggestion) {
                      _barangController.text = suggestion.namaBarang!;
                      kodeBarangCtrl.text = suggestion.kodeBarang;
                      satuanCtrl.text = suggestion.satuan!;
                      kelompokCtrl.text = suggestion.kelompok!;
                      hargaJualCtrl.text = suggestion.hargaJual.toString();
                      hargaBeliCtrl.text = suggestion.hargaBeli.toString();
                      disc1Ctrl.text = suggestion.jualDisc1.toString();
                      disc2Ctrl.text = suggestion.jualDisc2.toString();
                      disc3Ctrl.text = suggestion.jualDisc3.toString();
                      disc4Ctrl.text = suggestion.jualDisc4.toString();

                      Future.delayed(Duration(milliseconds: 100), () {
                        _isSelectingSuggestion = false;
                      });
                    },
                  ),
                  Visibility(
                    visible: false,
                    child: TextFormField(
                      controller: kodeBarangCtrl,
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'Kode Barang'),
                    ),
                  ),
                  Row(children: [
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: TextFormField(
                        controller: kelompokCtrl,
                        decoration: InputDecoration(labelText: 'Kelompok'),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: TextFormField(
                        controller: satuanCtrl,
                        decoration: InputDecoration(
                          labelText: 'Satuan',
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ]),
                  TextFormField(
                    controller: hargaBeliCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: 'Harga Beli'),
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      final number = int.parse(value.replaceAll('.', ''));
                      final newText =
                          formatCurrency.format(number).replaceAll(',00', '');
                      hargaBeliCtrl.value = TextEditingValue(
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
                    controller: hargaJualCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: 'Harga Jual'),
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      final number = int.parse(value.replaceAll('.', ''));
                      final newText =
                          formatCurrency.format(number).replaceAll(',00', '');
                      hargaJualCtrl.value = TextEditingValue(
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
                    controller: disc1Ctrl,
                    decoration: InputDecoration(labelText: 'Disc 1'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
                      final formatted =
                          formatCurrency.format(int.tryParse(clean) ?? 0);
                      if (value != formatted) {
                        disc1Ctrl.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Harap masukkan angka';
                      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
                      if (clean.isEmpty)
                        return 'Hanya angka yang diperbolehkan';

                      final hargaJual = int.tryParse(
                          hargaJualCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
                      final hargaBeli = int.tryParse(
                          hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
                      final disc = int.tryParse(clean);

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
                    controller: disc2Ctrl,
                    decoration: InputDecoration(labelText: 'Disc 2'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
                      final formatted =
                          formatCurrency.format(int.tryParse(clean) ?? 0);
                      if (value != formatted) {
                        disc2Ctrl.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Harap masukkan angka';
                      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
                      if (clean.isEmpty)
                        return 'Hanya angka yang diperbolehkan';

                      final hargaJual = int.tryParse(
                          hargaJualCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
                      final hargaBeli = int.tryParse(
                          hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
                      final disc = int.tryParse(clean);

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
                    controller: disc3Ctrl,
                    decoration: InputDecoration(labelText: 'Disc 3'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
                      final formatted =
                          formatCurrency.format(int.tryParse(clean) ?? 0);
                      if (value != formatted) {
                        disc3Ctrl.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Harap masukkan angka';
                      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
                      if (clean.isEmpty)
                        return 'Hanya angka yang diperbolehkan';

                      final hargaJual = int.tryParse(
                          hargaJualCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
                      final hargaBeli = int.tryParse(
                          hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
                      final disc = int.tryParse(clean);

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
                    controller: disc4Ctrl,
                    decoration: InputDecoration(labelText: 'Disc 4'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
                      final formatted =
                          formatCurrency.format(int.tryParse(clean) ?? 0);
                      if (value != formatted) {
                        disc4Ctrl.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Harap masukkan angka';
                      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
                      if (clean.isEmpty)
                        return 'Hanya angka yang diperbolehkan';

                      final hargaJual = int.tryParse(
                          hargaJualCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
                      final hargaBeli = int.tryParse(
                          hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
                      final disc = int.tryParse(clean);

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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: jumlahBeliCtrl,
                    decoration: InputDecoration(labelText: 'Jumlah Beli'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap masukkan angka';
                      }
                      // Menggunakan regex untuk memeriksa apakah input hanya angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null; // Valid
                    },
                  ),
                  Visibility(
                    visible: false,
                    child: TextFormField(
                      controller: totalHargaCtrl,
                      decoration: InputDecoration(labelText: 'Total Harga'),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  )
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
                if (data == null) {
                  if (kodeBarangCtrl.text == '') {
                    final shouldInsert = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Barang belum terdaftar'),
                        content: Text(
                            'Data barang belum ada. Ingin ditambahkan ke daftar barang?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Ya'),
                          ),
                        ],
                      ),
                    );

                    if (shouldInsert == true) {
                      String kodeBaru = await ApiService.generateKodeBarang();
                      // ✅ Insert ke tabel barangs
                      final raw = {
                        'kodeBarang': kodeBaru,
                        'namaBarang': _barangController.text,
                        'noRak': '',
                        'kelompok': kelompokCtrl.text,
                        'satuan': satuanCtrl.text,
                        'stokAktual': 0,
                        'hargaBeli': int.tryParse(hargaBeliCtrl.text
                                .replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0,
                        'hargaJual': int.tryParse(hargaJualCtrl.text
                                .replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0,
                        'jualDisc1': int.tryParse(disc1Ctrl.text
                                .replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0,
                        'jualDisc2': int.tryParse(disc2Ctrl.text
                                .replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0,
                        'jualDisc3': int.tryParse(disc3Ctrl.text
                                .replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0,
                        'jualDisc4': int.tryParse(disc4Ctrl.text
                                .replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0,
                      };
                      late http.Response response;
                      response = await ApiService.postBarang(raw);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        if (context.mounted) Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal menyimpan data')),
                        );
                      }
                      kodeBarangCtrl.text = kodeBaru;
                    } else {
                      return;
                    }
                  }
                  final raw2 = {
                    'username': 'Admin123',
                    'kodeBarang': kodeBarangCtrl.text,
                    'namaBarang': _barangController.text,
                    'kelompok': kelompokCtrl.text,
                    'satuan': satuanCtrl.text,
                    'hargaBeli': int.tryParse(hargaBeliCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'hargaJual': int.tryParse(hargaJualCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jualDisc1': int.tryParse(
                            disc1Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jualDisc2': int.tryParse(
                            disc2Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jualDisc3': int.tryParse(
                            disc3Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jualDisc4': int.tryParse(
                            disc4Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jumlahBeli': int.tryParse(jumlahBeliCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'totalHarga': int.tryParse(totalHargaCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                  };
                  late http.Response masuk;
                  masuk = await ApiService.postPembelianTmp(raw2);
                  if (masuk.statusCode == 200 || masuk.statusCode == 201) {
                    if (context.mounted) Navigator.pop(context);
                    await _loadPembelians(); // refresh data
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan data')),
                    );
                  }
                } else {
                  //updat
                  final raw3 = {
                    'id': data.id,
                    'username': 'Admin123',
                    'kodeBarang': kodeBarangCtrl.text,
                    'namaBarang': _barangController.text,
                    'kelompok': kelompokCtrl.text,
                    'satuan': satuanCtrl.text,
                    'hargaBeli': int.tryParse(hargaBeliCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'hargaJual': int.tryParse(hargaJualCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jualDisc1': int.tryParse(
                            disc1Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jualDisc2': int.tryParse(
                            disc2Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jualDisc3': int.tryParse(
                            disc3Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jualDisc4': int.tryParse(
                            disc4Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'jumlahBeli': int.tryParse(jumlahBeliCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'totalHarga': int.tryParse(totalHargaCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                  };
                  late http.Response update;
                  update = await ApiService.updatePembelianTmp(
                      data.id.toString(), raw3);

                  if (update.statusCode == 200 || update.statusCode == 201) {
                    if (context.mounted) Navigator.pop(context);
                    await _loadPembelians(); // refresh data
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan data')),
                    );
                  }
                }

                updateTotalSeluruh();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> updateTotalSeluruh() async {
    final total = await ApiService.getTotalHargaPembelianTmp('Admin123');
    totalpembelian = total == 0 ? '' : 'Rp. ${total.toString()}';
    setState(() {}); // Jika kamu ingin memperbarui tampilan setelah ini
  }

  void _deletePembelian(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus'),
        content: const Text('Yakin ingin menghapus ini?'),
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
      final response = await ApiService.deletePembelianTmp(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _loadPembelians(); // <-- refresh data di layar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Barang dipemblian ini berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus')),
        );
      }
    }
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
                  'Pembelian',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                Row(children: [
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
                          await importPembelianFromExcel(
                              file: file, db: db, onFinished: _loadPembelians);
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
                  ElevatedButton.icon(
                    onPressed: prosesbatal,
                    icon: const Icon(Icons.close),
                    label: const Text('Batal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .red, // Mengatur warna latar belakang menjadi merah
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  ElevatedButton.icon(
                    onPressed: prosesPembelian,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                  ),
                ])
              ],
            ),

            Divider(thickness: 1),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TextFormField(
                    controller: _nofaktur,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'No Faktur',
                    ),
                  ),
                ),
                SizedBox(width: 25),
                SizedBox(
                  height: 35,
                  width: 125,
                  child: ElevatedButton.icon(
                    onPressed: setNofaktur,
                    label: const Text('Otomatis'),
                  ),
                ),
                SizedBox(width: 100), // Spacing between the text fields
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TypeAheadFormField<SupplierModel>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _SupplierController,
                      onChanged: (value) {
                        if (!_isSelectingSupplier) {
                          // Kosongkan field jika user sedang mengetik (bukan dari suggestion)

                          _kodeSupplierController.clear();
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nama Supplier',
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      try {
                        final response =
                            await ApiService.searchSupplier(pattern);
                        return response
                            .map<SupplierModel>(
                                (json) => SupplierModel.fromJson(json))
                            .toList();
                      } catch (e) {
                        return [];
                      }
                    },
                    itemBuilder: (context, SupplierModel suggestion) {
                      return ListTile(
                        title: Text(suggestion.namaSupplier),
                        subtitle: Text('Kode: ${suggestion.kodeSupplier}'),
                      );
                    },
                    onSuggestionSelected: (SupplierModel suggestion) {
                      _SupplierController.text = suggestion.namaSupplier;
                      _kodeSupplierController.text = suggestion.kodeSupplier;

                      _supplierValid = true;
                      Future.delayed(Duration(milliseconds: 100), () {
                        _isSelectingSupplier = false;
                      });
                    },
                    validator: (value) {
                      if (!_supplierValid || value == null || value.isEmpty) {
                        return 'Pilih supplier dari daftar';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _supplierValid = true;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TextFormField(
                    controller: tanggalBeliCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Pembelian',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      FocusScope.of(context)
                          .requestFocus(FocusNode()); // hilangkan keyboard
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tanggalBeli ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        tanggalBeli = picked;
                        tanggalBeliCtrl.text = picked
                            .toIso8601String()
                            .split('T')
                            .first; // format ke yyyy-MM-dd
                      }
                    },
                  ),
                ),

                SizedBox(width: 250), // Spacing between the text fields
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TextFormField(
                    controller: _kodeSupplierController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Kode Supplier',
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Total : ${totalpembelian}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(width: 30), // Spacing between the text fields
                ElevatedButton.icon(
                  onPressed: () => showFormPembelianstmp(),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ],
            ),

            const SizedBox(height: 5),
            Divider(
              thickness: 0.5,
            ),
            // === HEADER DAFTAR SUPPLIER DAN DROPDOWN BARIS ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📋 List Barang',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blueGrey[900],
                      ),
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
                    headingRowHeight: 30,
                    headingTextStyle: const TextStyle(fontSize: 11),
                    columnSpacing: 20,
                    dataTextStyle: const TextStyle(fontSize: 10),
                    columns: const [
                      DataColumn(label: Text('Kode')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Kelompok')),
                      DataColumn(label: Text('Satuan')),
                      DataColumn(label: Text('Harga Beli')),
                      DataColumn(label: Text('Harga Jual')),
                      DataColumn(label: Text('Disc1')),
                      DataColumn(label: Text('Disc2')),
                      DataColumn(label: Text('Disc3')),
                      DataColumn(label: Text('Disc4')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: allPembeliantmp.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(Tooltip(
                            message: 'Kode Barang',
                            child: Text(p.kodeBarang),
                          )),
                          DataCell(Tooltip(
                            message: 'Nama Barang',
                            child: Text(p.namaBarang),
                          )),
                          DataCell(Tooltip(
                            message: 'Kelompok',
                            child: Text(p.kelompok),
                          )),
                          DataCell(Tooltip(
                            message: 'Satuan',
                            child: Text(p.satuan),
                          )),
                          DataCell(
                            Tooltip(
                              message: 'Harga Beli',
                              child: Text(formatter.format(p.hargaBeli)),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Harga Jual',
                              child: Text(formatter.format(p.hargaJual)),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Jual Disc 1',
                              child: Text(formatter.format(p.jualDisc1 ?? 0)),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Jual Disc 2',
                              child: Text(formatter.format(p.jualDisc2 ?? 0)),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Jual Disc 3',
                              child: Text(formatter.format(p.jualDisc3 ?? 0)),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Jual Disc 4',
                              child: Text(formatter.format(p.jualDisc4 ?? 0)),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Jumlah Beli',
                              child: Text(p.jumlahBeli.toString()),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Total Harga',
                              child: Text(formatter.format(p.totalHarga ?? 0)),
                            ),
                          ),
                          DataCell(Row(
                            children: [
                              IconButton(
                                tooltip: 'Hapus Data',
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => showFormPembelianstmp(data: p),
                              ),
                              IconButton(
                                tooltip: 'Hapus Data',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deletePembelian(p.id.toString()),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
