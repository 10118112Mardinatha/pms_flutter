import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/barang_model.dart';
import 'package:pms_flutter/models/doctor_model.dart';
import 'package:pms_flutter/models/pelanggan_model.dart';
import 'package:pms_flutter/models/reseptmp_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import '../database/app_database.dart';

class ResepScreen extends StatefulWidget {
  final UserModel user;
  const ResepScreen({super.key, required this.user});

  @override
  State<ResepScreen> createState() => _ResepScreenState();
}

class _ResepScreenState extends State<ResepScreen> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  final FocusNode _discFocusNode = FocusNode();
  final FocusNode _barangFocusNode = FocusNode();
  final FocusNode _jumlahbeliFocusNode = FocusNode();
  bool _isSelectingSuggestion = false;
  List<ResepTmpModel> allData = [];
  bool iscekumum = true;
  bool iscekpelanggan = false;
  bool iscekresep = false;
  final tanggalCtrl = TextEditingController(); // definisikan di atas
  DateTime? tanggal = DateTime.now();
  final TextEditingController _barangController = TextEditingController();
  final TextEditingController _jumlahbarangController = TextEditingController();
  final TextEditingController _pelangganController = TextEditingController();
  final TextEditingController _noResepController = TextEditingController();
  final TextEditingController _namaDoctorController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _kelompokController = TextEditingController();
  final TextEditingController _discController = TextEditingController();
  BarangModel? selectedBarang;
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
//formutama
  String kodedokter = '';
  String kodePelanggan = '';

//buat tmp
  String kodebarang = '';
  String satuan = '';
  String kelompok = '';
  int hargabeli = 0;
  int hargajual = 0;
  int jumlahjual = 0;
  int totalharga = 0;
  int totalhargastlhdiskon = 0;
  int totaldiskon = 0;

  @override
  void initState() {
    super.initState();
    widget.user.id;
    _loadResep();
  }

  Future<void> _loadResep() async {
    tanggalCtrl.text = DateTime.now().toIso8601String().split('T').first;

    final noresepbaru = await ApiService.generatenoResep();
    final data = await ApiService.fetchResepTmp(widget.user.username);
    setState(() {
      allData = data;
      _noResepController.text = noresepbaru;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> prosesSimpan() async {
    final noresep = _noResepController.text;
    final kdpelanggan = kodePelanggan;
    final namapelanggan = _pelangganController.text;
    final kddoctor = kodedokter;
    final namadoctor = _namaDoctorController.text;

    final alamat = _alamatController.text;
    final umur = int.tryParse(_umurController.text) ?? 0;
    final kelompokpelanggan = _kelompokController.text;
    final nohp = _noHpController.text;
    final keterangan = _keteranganController.text;
    final tanggalresep = tanggal;

    if (noresep.isEmpty || namapelanggan.isEmpty || tanggalresep == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tanggalresep.toString())),
      );
      return;
    }
    final data = {
      'noResep': noresep,
      'tanggal': tanggalresep.toIso8601String(),
      'namaPelanggan': namapelanggan,
      'kodePelanggan': kdpelanggan,
      'kelompokPelanggan': kelompokpelanggan,
      'kodeDoctor': kddoctor,
      'namaDoctor': namadoctor,
      'usia': umur,
      'alamat': alamat,
      'keterangan': keterangan,
      'noTelp': nohp
    };
    try {
      final bolehLanjut = await ApiService.cekNoResepBelumAda(noresep);

      if (!bolehLanjut) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No Faktur sudah digunakan')),
          );
        }
        return;
      }
      late http.Response response;
      response = await ApiService.pindahResep(data, widget.user.username);

      ///jgn lupa

      if (!mounted) return; // <-- ini cek awal, sebelum lanjut
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep berhasil disimpan')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        await ApiService.logActivity(widget.user.id,
            'Menambah Resep ${noresep} dengan nama ${namapelanggan}');
        _pelangganController.clear();
        _namaDoctorController.clear();
        kodePelanggan = '';
        kodedokter = '';
        tanggal = DateTime.now();
        tanggalCtrl.clear();
        _alamatController.clear();
        _kelompokController.clear();
        _umurController.clear();
        _keteranganController.clear();
        _noHpController.clear();
        // Refresh tampilan
        _loadResep();
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
    respon =
        await ApiService.deleteResepTmpUser(widget.user.username); // jgn lupa
    // Reset form input
    _pelangganController.clear();
    _namaDoctorController.clear();
    kodePelanggan = '';
    kodedokter = '';
    tanggal = DateTime.now();
    tanggalCtrl.clear();
    _alamatController.clear();
    _kelompokController.clear();
    _umurController.clear();
    _keteranganController.clear();
    _noHpController.clear();
    _loadResep();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> ProsesTambahresep() async {
    String namabarang = _barangController.text;
    jumlahjual = int.tryParse(_jumlahbarangController.text) ?? 0;
    int jualdiscon =
        int.tryParse(_discController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
            hargajual;
    totalharga = (hargajual * jumlahjual);
    totalhargastlhdiskon = (jualdiscon * jumlahjual);
    totaldiskon = totalharga - totalhargastlhdiskon;

    if (namabarang != '') {
      final dat = {
        'username': widget.user.username, // jgn lupa
        'kodeBarang': kodebarang,
        'namaBarang': _barangController.text,
        'kelompok': kelompok,
        'satuan': satuan,
        'hargaBeli': hargabeli,
        'hargaJual': hargajual,
        'jualDiscon': jualdiscon,
        'jumlahJual': jumlahjual,
        'totalHargaSebelumDisc': totalharga,
        'totalHargaSetelahDisc': totalhargastlhdiskon,
        'totalDisc': totaldiskon,
      };
      late http.Response response;
      response = await ApiService.postResepTmp(dat);
      if (!mounted) return; // <-- ini cek awal, sebelum lanjut
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil masuk ke resep')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        _barangController.clear();
        _jumlahbarangController.clear();
        _discController.clear();
        kodebarang = '';
        satuan = '';
        kelompok = '';
        hargabeli = 0;
        hargajual = 0;
        jumlahjual = 0;
        totalharga = 0;
        totalhargastlhdiskon = 0;
        totaldiskon = 0;
        selectedBarang = null;
        _loadResep();
        _barangFocusNode.requestFocus();
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
    }
  }

  void _deleteResep(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus'),
        content: const Text('Yakin ingin menghapus data ini?'),
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
      final response = await ApiService.deleteResepTmp(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _loadResep(); // <-- refresh data di layar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang di Resep ini berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus')),
        );
      }
    }
  }

  Future<void> _showForm({ResepTmpModel? data}) async {
    final formKey = GlobalKey<FormState>();
    final kodebarangCtrl = TextEditingController(text: data?.kodeBarang ?? '');
    final namabarangCtrl = TextEditingController(text: data?.namaBarang ?? '');
    final jualdiscCtrl =
        TextEditingController(text: data?.jualDiscon?.toString() ?? '');
    final jumlahCtrl =
        TextEditingController(text: data?.jumlahJual.toString() ?? '');

    final jualdiscFocusNode = FocusNode();

    BarangModel? pilihBarang =
        await ApiService.fetchBarangByKodefodiscon(kodebarangCtrl.text);

    Future<void> _submitForm() async {
      print('Submit form triggered');
      if (formKey.currentState!.validate()) {
        if (data != null) {
          int jumlah = int.tryParse(jumlahCtrl.text) ?? 0;
          int totalhar = data.hargaJual * jumlah;
          int jualdis = int.tryParse(jualdiscCtrl.text) ?? data.hargaJual;
          int totalstlhdisc = jualdis * jumlah;
          int totaldis = totalhar - totalstlhdisc;
          final dat = {
            'id': data.id,
            'username': widget.user.username,
            'kodeBarang': kodebarangCtrl.text,
            'namaBarang': namabarangCtrl.text,
            'kelompok': data.kelompok,
            'satuan': data.satuan,
            'hargaBeli': data.hargaBeli,
            'hargaJual': data.hargaJual,
            'jualDiscon': int.tryParse(jualdiscCtrl.text),
            'jumlahJual': int.tryParse(jumlahCtrl.text),
            'totalHargaSebelumDisc': totalhar,
            'totalHargaSetelahDisc': totalstlhdisc,
            'totalDisc': totaldis,
          };

          try {
            final update =
                await ApiService.updateResepTmp(data.id.toString(), dat);

            if (update.statusCode == 200 || update.statusCode == 201) {
              if (context.mounted) Navigator.pop(context);
              await _loadResep(); // refresh data
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal menyimpan data')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        }
      } else {
        print('Validasi gagal');
      }
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(data == null ? 'Tambah' : 'Edit'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: kodebarangCtrl,
                  decoration: InputDecoration(labelText: 'Kode barang'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: namabarangCtrl,
                  decoration: InputDecoration(labelText: 'Nama'),
                  readOnly: true,
                ),
                TypeAheadFormField<Map<String, dynamic>>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: jualdiscCtrl,
                    focusNode: jualdiscFocusNode,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Jual Diskon',
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) async {
                      await _submitForm();
                    },
                  ),
                  suggestionsCallback: (pattern) {
                    if (pilihBarang == null) return [];

                    final discs = <Map<String, dynamic>>[];

                    if (pilihBarang.jualDisc1 != null &&
                        pilihBarang.jualDisc1 != 0) {
                      discs.add({
                        'label': 'Diskon 1',
                        'value': pilihBarang.jualDisc1,
                      });
                    }
                    if (pilihBarang.jualDisc2 != null &&
                        pilihBarang.jualDisc2 != 0) {
                      discs.add({
                        'label': 'Diskon 2',
                        'value': pilihBarang.jualDisc2,
                      });
                    }
                    if (pilihBarang.jualDisc3 != null &&
                        pilihBarang.jualDisc3 != 0) {
                      discs.add({
                        'label': 'Diskon 3',
                        'value': pilihBarang.jualDisc3,
                      });
                    }
                    if (pilihBarang.jualDisc4 != null &&
                        pilihBarang.jualDisc4 != 0) {
                      discs.add({
                        'label': 'Diskon 4',
                        'value': pilihBarang.jualDisc4,
                      });
                    }

                    return discs
                        .where((d) => d['value'].toString().contains(pattern));
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['value'].toString()),
                      subtitle: Text(suggestion['label']),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    jualdiscCtrl.text = suggestion['value'].toString();
                  },
                  noItemsFoundBuilder: (context) =>
                      Text('Diskon tidak tersedia'),
                ),
                TextFormField(
                  controller: jumlahCtrl,
                  decoration: InputDecoration(labelText: 'Jumlah jual'),
                  onFieldSubmitted: (_) => _submitForm(),
                  keyboardType: TextInputType.number,
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _submitForm();
            },
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
    );
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
                  'Resep',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                      onPressed: prosesSimpan,
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
            Divider(
              thickness: 0.7,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35,
                  width: 200,
                  child: TextFormField(
                    controller: _noResepController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: 'No Resep',
                    ),
                    readOnly: true,
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  height: 35,
                  width: 200,
                  child: TextFormField(
                    controller: tanggalCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      FocusScope.of(context)
                          .requestFocus(FocusNode()); // hilangkan keyboard
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tanggal ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        tanggal = picked;
                        tanggalCtrl.text = picked
                            .toIso8601String()
                            .split('T')
                            .first; // format ke yyyy-MM-dd
                      }
                    },
                  ),
                ),
                SizedBox(width: 15),
                Row(children: [
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TypeAheadField<DoctorModel>(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(),
                          labelText: 'Kode/Nama Dokter',
                        ),
                        controller: _namaDoctorController,
                      ),
                      suggestionsCallback: (pattern) async {
                        try {
                          final response =
                              await ApiService.searchDoctor(pattern);
                          return response
                              .map<DoctorModel>(
                                  (json) => DoctorModel.fromJson(json))
                              .toList();
                        } catch (e) {
                          return [];
                        }
                      },
                      itemBuilder: (context, DoctorModel suggestion) {
                        return ListTile(
                          title: Text(suggestion.namaDoctor),
                          subtitle: Text('Kode: ${suggestion.kodeDoctor}'),
                        );
                      },
                      onSuggestionSelected: (DoctorModel suggestion) {
                        _namaDoctorController.text = suggestion.namaDoctor;
                        kodedokter = suggestion.kodeDoctor;
                      },
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35,
                  width: 200,
                  child: TypeAheadField<PelangganModel>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'Kode/Nama Pelanggan',
                      ),
                      controller: _pelangganController,
                    ),
                    suggestionsCallback: (pattern) async {
                      try {
                        final response =
                            await ApiService.searchPelanggan(pattern);
                        return response
                            .map<PelangganModel>(
                                (json) => PelangganModel.fromJson(json))
                            .toList();
                      } catch (e) {
                        return [];
                      }
                    },
                    itemBuilder: (context, PelangganModel suggestion) {
                      return ListTile(
                        title: Text(suggestion.namaPelanggan),
                        subtitle: Text('Kode: ${suggestion.kodePelanggan}'),
                      );
                    },
                    onSuggestionSelected: (PelangganModel suggestion) {
                      _pelangganController.text = suggestion.namaPelanggan;
                      kodePelanggan = suggestion.kodePelanggan;
                      _alamatController.text = suggestion.alamat!;
                      _umurController.text = suggestion.usia.toString();
                      _kelompokController.text = suggestion.kelompok!;
                      _noHpController.text = suggestion.telepon.toString();
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: 35,
                  width: 280,
                  child: TextFormField(
                    controller: _alamatController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Alamat',
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                SizedBox(
                  height: 35,
                  width: 100,
                  child: TextFormField(
                    controller: _umurController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: 'Umur',
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: 35,
                  width: 200,
                  child: TextFormField(
                    controller: _kelompokController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: 'Kelompok',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35,
                  width: 200,
                  child: TextFormField(
                    controller: _noHpController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'No Hp',
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: 35,
                  width: 280,
                  child: TextFormField(
                    controller: _keteranganController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: 'Keterangan',
                    ),
                  ),
                ),
              ],
            ),
            Divider(thickness: 0.7),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TypeAheadField<BarangModel>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'Masukan barang ke resep',
                      ),
                      controller: _barangController,
                      focusNode: _barangFocusNode,
                      onChanged: (value) {
                        if (!_isSelectingSuggestion) {
                          // Kosongkan field jika user sedang mengetik (bukan dari suggestion)
                          _jumlahbarangController.clear();
                          _discController.clear();
                          selectedBarang = null;
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
                      }
                    },
                    itemBuilder: (context, BarangModel suggestion) {
                      return ListTile(
                        title: Text(suggestion.namaBarang!),
                        subtitle: Text('Kode: ${suggestion.kodeBarang}'),
                      );
                    },
                    onSuggestionSelected: (BarangModel suggestion) async {
                      _barangController.text = suggestion.namaBarang!;
                      kodebarang = suggestion.kodeBarang;
                      kelompok = suggestion.kelompok!;
                      satuan = suggestion.satuan!;
                      hargabeli = suggestion.hargaBeli;
                      hargajual = suggestion.hargaJual;
                      _jumlahbeliFocusNode.requestFocus();
                      selectedBarang =
                          await ApiService.fetchBarangByKodefodiscon(
                              kodebarang);
                      Future.delayed(Duration(milliseconds: 100), () {
                        _isSelectingSuggestion = false;
                      });
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  height: 35,
                  width: 75,
                  child: TextFormField(
                    controller: _jumlahbarangController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: 'Jumlah',
                    ),
                    onFieldSubmitted: (_) => ProsesTambahresep(),
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TypeAheadFormField<Map<String, dynamic>>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _discController,
                      focusNode: _discFocusNode,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'Pilih Diskon',
                      ),
                      onSubmitted: (_) => ProsesTambahresep(),
                    ),
                    suggestionsCallback: (pattern) {
                      if (selectedBarang == null) return [];

                      final discs = <Map<String, dynamic>>[];

                      if (selectedBarang!.jualDisc1 != null &&
                          selectedBarang!.jualDisc1 != 0) {
                        discs.add({
                          'label': 'Diskon 1',
                          'value': selectedBarang!.jualDisc1
                        });
                      }
                      if (selectedBarang!.jualDisc2 != null &&
                          selectedBarang!.jualDisc2 != 0) {
                        discs.add({
                          'label': 'Diskon 2',
                          'value': selectedBarang!.jualDisc2
                        });
                      }
                      if (selectedBarang!.jualDisc3 != null &&
                          selectedBarang!.jualDisc3 != 0) {
                        discs.add({
                          'label': 'Diskon 3',
                          'value': selectedBarang!.jualDisc3
                        });
                      }
                      if (selectedBarang!.jualDisc4 != null &&
                          selectedBarang!.jualDisc4 != 0) {
                        discs.add({
                          'label': 'Diskon 4',
                          'value': selectedBarang!.jualDisc4
                        });
                      }

                      return discs.where(
                          (d) => d['value'].toString().contains(pattern));
                    },
                    itemBuilder: (context, suggestion) {
                      final formatted =
                          currencyFormatter.format(suggestion['value']);
                      return ListTile(
                        title: Text(formatted),
                        subtitle: Text(suggestion['label']),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _discController.text =
                          currencyFormatter.format(suggestion['value']);
                      _discFocusNode.requestFocus();
                    },
                    noItemsFoundBuilder: (context) =>
                        Text('Diskon tidak tersedia'),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  onPressed: ProsesTambahresep,
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
            SizedBox(height: 15),
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
                      DataColumn(label: Text('Harga beli')),
                      DataColumn(label: Text('Harga Jual')),
                      DataColumn(label: Text('Jual Disc')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Total stlh disc')),
                      DataColumn(label: Text('Total Disc')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: allData.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(Text(p.kodeBarang)),
                          DataCell(Text(p.namaBarang)),
                          DataCell(Text(p.kelompok)),
                          DataCell(Text(p.satuan)),
                          DataCell(Text(formatter.format(p.hargaBeli))),
                          DataCell(Text(formatter.format(p.hargaJual))),
                          DataCell(Text(
                              formatter.format(p.jualDiscon ?? 0).toString())),
                          DataCell(Text((p.jumlahJual ?? 0).toString())),
                          DataCell(Text(formatter
                              .format(p.totalHargaSebelumDisc ?? 0)
                              .toString())),
                          DataCell(Text(formatter
                              .format(p.totalHargaSetelahDisc ?? 0)
                              .toString())),
                          DataCell(Text(
                              formatter.format(p.totalDisc ?? 0).toString())),
                          DataCell(Row(
                            children: [
                              IconButton(
                                tooltip: 'Edit Data',
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showForm(data: p),
                              ),
                              IconButton(
                                tooltip: 'Hapus Data',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteResep(p.id.toString()),
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
          ],
        ),
      ),
    );
  }
}
