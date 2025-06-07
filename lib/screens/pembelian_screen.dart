import 'dart:io';
import 'dart:ui';

/* import 'package:file_picker/file_picker.dart'; */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/supplier_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import '../database/app_database.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pms_flutter/models/barang_model.dart';
import 'package:pms_flutter/models/pembeliantmp_model.dart';

class PembelianScreen extends StatefulWidget {
  final UserModel user;
  const PembelianScreen({super.key, required this.user});

  @override
  State<PembelianScreen> createState() => _PembelianScreenState();
}

class _PembelianScreenState extends State<PembelianScreen> {
  List<PembelianTmpModel> allPembeliantmp = [];
  bool _isSelectingSupplier = false;
  String searchField = 'Nama';
  String searchText = '';
  final username = 'username';
  Pembelian? data;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nofaktur = TextEditingController();
  final TextEditingController _SupplierController = TextEditingController();
  final TextEditingController _kodeSupplierController = TextEditingController();
  final expiredCtrl = TextEditingController();
  final tanggalBeliCtrl = TextEditingController();
  DateTime? tanggalBeli = DateTime.now();
  final TextEditingController totalSeluruhCtrl = TextEditingController();
  int? totalpembelian;
  bool _supplierValid = false;
  Supplier? selectedSupplier;
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final searchOptions = ['Kode'];

  @override
  void initState() {
    super.initState();
    widget.user.id;
    _loadPembelians();
  }

  Future<void> _loadPembelians() async {
    final data = await ApiService.fetchPembelianTmp(widget.user.username);
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
      response = await ApiService.pindahPembelian(data, widget.user.username);

      if (!mounted) return; // <-- ini cek awal, sebelum lanjut
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pembelian berhasil disimpan')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        await ApiService.logActivity(
            widget.user.id, 'Menambahkan pembelian ${noFaktur}');
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
    respon = await ApiService.deletePembelianTmpUser(widget.user.username);
    // Reset form input
    _nofaktur.clear();
    _kodeSupplierController.clear();
    _SupplierController.clear();
    tanggalBeli = null;
    tanggalBeliCtrl.clear();
    totalSeluruhCtrl.clear();
    _loadPembelians();
  }

//
  Future<void> showFormPembelianstmp({
    PembelianTmpModel? data,
  }) async {
    final formKey = GlobalKey<FormState>();
    bool _isSelectingSuggestion = false;
    String? validateDisc(String? value, TextEditingController hargaJualCtrl,
        TextEditingController hargaBeliCtrl) {
      if (value == null || value.isEmpty) return 'Harap masukkan angka';

      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.isEmpty) return 'Hanya angka yang diperbolehkan';

      final hargaJual =
          int.tryParse(hargaJualCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final hargaBeli =
          int.tryParse(hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final disc = int.tryParse(clean);

      if (hargaJual == null || hargaBeli == null) {
        return 'Isi harga beli & harga jual terlebih dahulu';
      }

      if (disc != null && disc > hargaJual) {
        return 'Diskon tidak boleh lebih besar dari harga jual';
      }

      return null;
    }

    final kodeBarangCtrl = TextEditingController(text: data?.kodeBarang ?? '');
    final kelompokCtrl = TextEditingController(text: data?.kelompok ?? '');
    final satuanCtrl = TextEditingController(text: data?.satuan ?? '');
    final ketranganctrl = TextEditingController(text: data?.keterangan ?? '');
    final jumlahBeliCtrl =
        TextEditingController(text: data?.jumlahBeli?.toString() ?? '');
    final formatCurrency =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    final hargaBeliCtrl = TextEditingController(
      text:
          data?.hargaBeli != null ? formatCurrency.format(data!.hargaBeli) : '',
    );

    final hargaJualCtrl = TextEditingController(
      text:
          data?.hargaJual != null ? formatCurrency.format(data!.hargaJual) : '',
    );

    final disc1Ctrl = TextEditingController(
      text:
          data?.jualDisc1 != null ? formatCurrency.format(data!.jualDisc1) : '',
    );

    final disc2Ctrl = TextEditingController(
      text:
          data?.jualDisc1 != null ? formatCurrency.format(data!.jualDisc2) : '',
    );
    final disc3Ctrl = TextEditingController(
      text:
          data?.jualDisc3 != null ? formatCurrency.format(data!.jualDisc3) : '',
    );
    final disc4Ctrl = TextEditingController(
      text:
          data?.jualDisc4 != null ? formatCurrency.format(data!.jualDisc4) : '',
    );

    final totalHargaCtrl = TextEditingController(
      text: data?.totalHarga != null
          ? formatCurrency.format(data!.totalHarga)
          : '',
    );

    final TextEditingController _barangController =
        TextEditingController(text: data?.namaBarang ?? '');

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

    void _handleSimpan() async {
      if (!formKey.currentState!.validate()) return;

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
            final raw = {
              'kodeBarang': kodeBaru,
              'namaBarang': _barangController.text,
              'noRak': '',
              'kelompok': kelompokCtrl.text,
              'satuan': satuanCtrl.text,
              'stokAktual': 0,
              'hargaBeli': int.tryParse(
                      hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
              'hargaJual': int.tryParse(
                      hargaJualCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
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
              'keterangan': ketranganctrl.text,
            };

            await ApiService.postBarang(raw);
            kodeBarangCtrl.text = kodeBaru;
          } else {
            return;
          }
        }

        final raw2 = {
          'username': widget.user.username,
          'kodeBarang': kodeBarangCtrl.text,
          'namaBarang': _barangController.text,
          'kelompok': kelompokCtrl.text,
          'satuan': satuanCtrl.text,
          'hargaBeli': int.tryParse(
                  hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0,
          'hargaJual': int.tryParse(
                  hargaJualCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0,
          'jualDisc1':
              int.tryParse(disc1Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'jualDisc2':
              int.tryParse(disc2Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'jualDisc3':
              int.tryParse(disc3Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'jualDisc4':
              int.tryParse(disc4Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'jumlahBeli': int.tryParse(
                  jumlahBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0,
          'totalHarga': int.tryParse(
                  totalHargaCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0,
          'keterangan': ketranganctrl.text
        };

        final masuk = await ApiService.postPembelianTmp(raw2);
        if (masuk.statusCode == 200 || masuk.statusCode == 201) {
          if (context.mounted) Navigator.pop(context);
          await _loadPembelians();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Gagal menyimpan data')));
        }
      } else {
        final raw3 = {
          'id': data!.id,
          'username': widget.user.username,
          'kodeBarang': kodeBarangCtrl.text,
          'namaBarang': _barangController.text,
          'kelompok': kelompokCtrl.text,
          'satuan': satuanCtrl.text,
          'hargaBeli': int.tryParse(
                  hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0,
          'hargaJual': int.tryParse(
                  hargaJualCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0,
          'jualDisc1':
              int.tryParse(disc1Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'jualDisc2':
              int.tryParse(disc2Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'jualDisc3':
              int.tryParse(disc3Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'jualDisc4':
              int.tryParse(disc4Ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0,
          'jumlahBeli': int.tryParse(
                  jumlahBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0,
          'totalHarga': int.tryParse(
                  totalHargaCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0,
          'keterangan': ketranganctrl.text,
        };

        final update =
            await ApiService.updatePembelianTmp(data!.id.toString(), raw3);
        if (update.statusCode == 200 || update.statusCode == 201) {
          if (context.mounted) Navigator.pop(context);
          await _loadPembelians();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Gagal menyimpan data')));
        }
      }

      updateTotalSeluruh();
    }

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
                          ketranganctrl.clear();
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
                      ketranganctrl.text = suggestion.keterangan!;

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
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Wajib diisi tidak boleh kosong';

                      final hargaJual =
                          int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
                      final hargaBeli = int.tryParse(
                          hargaBeliCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));

                      if (hargaJual == null || hargaBeli == null) {
                        return 'Harga beli dan jual harus diisi';
                      }

                      if (hargaJual < hargaBeli) {
                        return 'Harga jual tidak boleh lebih kecil dari harga beli';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: disc1Ctrl,
                    decoration: InputDecoration(labelText: 'Harga Disc 1'),
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
                    validator: (value) =>
                        validateDisc(value, hargaJualCtrl, hargaBeliCtrl),
                  ),
                  TextFormField(
                    controller: disc2Ctrl,
                    decoration: InputDecoration(labelText: 'Harga Disc 2'),
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
                    validator: (value) =>
                        validateDisc(value, hargaJualCtrl, hargaBeliCtrl),
                  ),
                  TextFormField(
                    controller: disc3Ctrl,
                    decoration: InputDecoration(labelText: 'Harga Disc 3'),
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
                    validator: (value) =>
                        validateDisc(value, hargaJualCtrl, hargaBeliCtrl),
                  ),
                  TextFormField(
                    controller: disc4Ctrl,
                    decoration: InputDecoration(labelText: 'Harga Disc 4'),
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
                    validator: (value) =>
                        validateDisc(value, hargaJualCtrl, hargaBeliCtrl),
                  ),
                  TextFormField(
                    controller: ketranganctrl,
                    onFieldSubmitted: (_) => _handleSimpan(),
                    decoration: InputDecoration(labelText: 'Keterangan'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: jumlahBeliCtrl,
                    onFieldSubmitted: (_) => _handleSimpan(),
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // warna teks tombol batal
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _handleSimpan,
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

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> updateTotalSeluruh() async {
    final total =
        await ApiService.getTotalHargaPembelianTmp(widget.user.username);
    totalpembelian = total;
    setState(() {}); // Jika kamu ingin memperbarui tampilan setelah ini
  }

  void _deletePembelian(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus'),
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
      final response = await ApiService.deletePembelianTmp(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _loadPembelians(); // <-- refresh data di layar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Barang dipembelian ini berhasil dihapus')),
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
                  '📥 Pembelian',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*  IconButton(
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
                              await ApiService.importPembelianFromExcel(
                                  file, username);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Import berhasil!')),
                            );
                            await _loadPembelians(); // Refresh data tabel
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
                    const SizedBox(width: 15),*/
                    ElevatedButton.icon(
                      onPressed: prosesbatal,
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 20),
                      label: const Text(
                        'Batal',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        minimumSize: const Size(100, 40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        shadowColor: Colors.redAccent.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton.icon(
                      onPressed: prosesPembelian,
                      icon:
                          const Icon(Icons.save, color: Colors.white, size: 20),
                      label: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        minimumSize: const Size(130, 40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),
                      ),
                    ),
                  ],
                )
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
                  height: 32,
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: setNofaktur,
                    icon: const Icon(
                      Icons.autorenew,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Otomatis',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // warna fresh & profesional
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shadowColor: Colors.teal.withOpacity(0.3),
                      minimumSize: Size.zero, // penting biar kecil beneran
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // hapus area kosong
                    ),
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
                    '${formatter.format(totalpembelian ?? 0)}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(width: 30), // Spacing between the text fields
                SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () => showFormPembelianstmp(),
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text(
                    'Tambah',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(100, 40), // ukuran lebih compact
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    shadowColor: Colors.greenAccent.withOpacity(0.4),
                  ),
                )
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
                        MaterialStateProperty.all(Colors.blue.shade300),
                    dataRowColor: MaterialStateProperty.all(Colors.white),
                    border: TableBorder.all(color: Colors.grey.shade300),
                    headingRowHeight: 30,
                    headingTextStyle: const TextStyle(fontSize: 11),
                    columnSpacing: 10,
                    dataTextStyle: const TextStyle(fontSize: 11),
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
                      DataColumn(label: Text('Keterangan')),
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
                          DataCell(SizedBox(
                              width: 130,
                              child: Tooltip(
                                message: 'Nama Barang',
                                child: Text(
                                  p.namaBarang,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))),
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
                              message: 'Harga Jual Disc 1',
                              child: Text(formatter.format(p.jualDisc1 ?? 0)),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Harga Jual Disc 2',
                              child: Text(formatter.format(p.jualDisc2 ?? 0)),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Harga Jual Disc 3',
                              child: Text(formatter.format(p.jualDisc3 ?? 0)),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: 'Harga Jual Disc 4',
                              child: Text(formatter.format(p.jualDisc4 ?? 0)),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 100,
                              child: Tooltip(
                                message: p.keterangan ?? '',
                                padding: const EdgeInsets.all(8),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                textStyle: const TextStyle(color: Colors.white),
                                preferBelow: true,
                                child: Text(
                                  p.keterangan ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
                                tooltip: 'Edit Data',
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
