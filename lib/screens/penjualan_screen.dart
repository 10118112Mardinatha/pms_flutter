import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/barang_model.dart';
import 'package:pms_flutter/models/doctor_model.dart';
import 'package:pms_flutter/models/pelanggan_model.dart';
import 'package:pms_flutter/models/penjualantmp_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import '../database/app_database.dart';
import 'package:intl/intl.dart';

class PenjualanScreen extends StatefulWidget {
  final UserModel user;
  const PenjualanScreen({super.key, required this.user});

  @override
  State<PenjualanScreen> createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  List<PenjualanTmpModel> allPenjualantmp = [];
  bool _isSelectingSuggestion = false;
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  final FocusNode _discFocusNode = FocusNode();
  final FocusNode _barangFocusNode = FocusNode();
  final FocusNode _jumlahbeliFocusNode = FocusNode();
  bool iscekumum = true;
  bool iscekpelanggan = false;
  bool iscekresep = false;
  final tanggaljualCtrl = TextEditingController(); // definisikan di atas
  DateTime? tanggaljual = DateTime.now();
  final TextEditingController _barangController = TextEditingController();
  final TextEditingController _jumlahbarangController = TextEditingController();
  final TextEditingController _pelangganController = TextEditingController();
  final TextEditingController _nofakturController = TextEditingController();
  final TextEditingController _discController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final formatCurrency =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  DateTime? tgexpired;
  String kodeDoctor = ' ';
  BarangModel? selectedBarang;
  int? totalpenjualan;
  String kodebarang = '';
  int idstok = 0;
  int sisaStok = 0;
  String kodepelanggan = ' ';
  String satuan = '';
  String kelompok = '';
  String? keterangan;
  int hargabeli = 0;
  int hargajual = 0;
  int jualdiscon = 0;
  int jumlahjual = 0;
  int totalharga = 0;
  int totalhargastlhdiskon = 0;
  int totaldiskon = 0;
  final formatter = NumberFormat.decimalPattern('id');
  @override
  void initState() {
    super.initState();
    widget.user.id;
    _loadPenjualan();
  }

  Future<void> _loadPenjualan() async {
    final data = await ApiService.fetchPenjualanTmp(widget.user.username);
    tanggaljualCtrl.text = DateTime.now().toIso8601String().split('T').first;
    final nofakturbaru = await ApiService.generatenofakturpenjualan();

    setState(() {
      allPenjualantmp = data;
      _nofakturController.text = nofakturbaru;
    });
    updateTotalSeluruh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> ProsesPenjualan() async {
    String namabarang = _barangController.text;
    jumlahjual = int.tryParse(_jumlahbarangController.text) ?? 0;
    int jualdiscon =
        int.tryParse(_discController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
            hargajual;
    totalharga = (hargajual * jumlahjual);
    totalhargastlhdiskon = (jualdiscon * jumlahjual);
    totaldiskon = totalharga - totalhargastlhdiskon;
    final sisa = sisaStok;

    if (namabarang != '') {
      if (jumlahjual != null && sisaStok != null && jumlahjual! > sisa!) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Stok Tidak Cukup'),
            content: Text(
                'Stok tersedia hanya $sisaStok, tetapi jumlah jual $jumlahjual.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        return; // ❌ Jangan lanjut insert
      }
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
        'status': 'menunggu',
      };
      late http.Response response;
      response = await ApiService.postPenjualanTmp(dat);
      if (!mounted) return; // <-- ini cek awal, sebelum lanjut
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil masuk ke penjualan')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        _barangController.clear();
        _discController.clear();
        _jumlahbarangController.clear();
        selectedBarang = null;
        _loadPenjualan();
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

  Future<void> updateTotalSeluruh() async {
    final total =
        await ApiService.getTotalHargaPenjualanTmp(widget.user.username);
    totalpenjualan = total;
    setState(() {});
  }

  Future<void> prosesbatal() async {
    // Bersihkan tabel pembelianstmp
    late http.Response respon;
    respon = await ApiService.deletePenjualanTmpUser(widget.user.username);

    // Reset form input
    _loadPenjualan();
    _doctorController.clear();
    kodeDoctor = '';
    kodepelanggan = '';
    _pelangganController.clear();
  }

  void _deletepenjualantmp(String id) async {
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
      final response = await ApiService.deletePenjualanTmp(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _loadPenjualan(); // <-- refresh data di layar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Barang di Penjualan ini berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus')),
        );
      }
    }
  }

  Future<void> _showForm({PenjualanTmpModel? penjualanstmp}) async {
    final formKey = GlobalKey<FormState>();
    final kodebarangCtrl =
        TextEditingController(text: penjualanstmp?.kodeBarang ?? '');
    final namabarangCtrl =
        TextEditingController(text: penjualanstmp?.namaBarang ?? '');
    final jualdiscCtrl = TextEditingController(
      text: penjualanstmp?.jualDiscon != null
          ? NumberFormat.currency(
                  locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
              .format(penjualanstmp!.jualDiscon)
          : '',
    );
    final hargajual = TextEditingController(
      text: penjualanstmp?.hargaJual != null
          ? NumberFormat.currency(
                  locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
              .format(penjualanstmp!.jualDiscon)
          : '',
    );
    final jumlahCtrl =
        TextEditingController(text: penjualanstmp?.jumlahJual.toString() ?? '');
    BarangModel? pilihBarang =
        await ApiService.fetchBarangByKodefodiscon(kodebarangCtrl.text);

    int idstokupdate = 0;
    int sisaStokupdate = 0;
    void _handleSimpan() async {
      if (penjualanstmp != null) {
        int sisaStokupdate = pilihBarang?.stokAktual ?? 0;
        int jumlah = int.tryParse(jumlahCtrl.text) ?? 0;
        if (jumlah > sisaStokupdate) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Stok Tidak Cukup'),
              content: Text(
                  'Stok tersedia hanya $sisaStokupdate, tetapi jumlah jual $jumlah.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text('OK'))
              ],
            ),
          );
          return;
        }

        int jumlahbeli = int.tryParse(jumlahCtrl.text) ?? 0;
        int totalhar = penjualanstmp!.hargaJual * jumlahbeli;
        int jualdis =
            int.tryParse(jualdiscCtrl.text) ?? penjualanstmp!.hargaJual;
        int totalstlhdisc = jualdis * jumlahbeli;
        int totaldis = totalhar - totalstlhdisc;

        final dat = {
          'id': penjualanstmp!.id,
          'username': widget.user.username,
          'kodeBarang': kodebarangCtrl.text,
          'namaBarang': namabarangCtrl.text,
          'kelompok': penjualanstmp!.kelompok,
          'satuan': penjualanstmp!.satuan,
          'hargaBeli': penjualanstmp!.hargaBeli,
          'hargaJual': penjualanstmp!.hargaJual,
          'jualDiscon': jualdis,
          'jumlahJual': jumlahbeli,
          'totalHargaSebelumDisc': totalhar,
          'totalHargaSetelahDisc': totalstlhdisc,
          'totalDisc': totaldis,
          'status': 'menunggu',
        };

        final update = await ApiService.updatePenjualanTmp(
            penjualanstmp!.id.toString(), dat);

        if (update.statusCode == 200 || update.statusCode == 201) {
          if (context.mounted) Navigator.pop(context);
          await _loadPenjualan();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Gagal menyimpan data')));
        }
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            PenjualanScreen == null ? 'Tambah Penjualan' : 'Edit Penjualan'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 12.0), // kasih spasi bawah
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110, // lebar label tetap, agar rata
                        child: Text(
                          'Kode Barang:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right, // ratakan kanan
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(kodebarangCtrl.text),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          'Nama Barang:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(namabarangCtrl.text),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          'Harga Jual:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp ',
                            decimalDigits: 0,
                          ).format(int.tryParse(hargajual.text) ?? 0),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TypeAheadFormField<Map<String, dynamic>>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: jualdiscCtrl,
                      onSubmitted: (_) => _handleSimpan(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        labelText: 'Jual Diskon',
                        border: OutlineInputBorder(), // kasih border tegas
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      if (pilihBarang == null) return [];

                      final discs = <Map<String, dynamic>>[];

                      if (pilihBarang!.jualDisc1 != null &&
                          pilihBarang!.jualDisc1 != 0) {
                        discs.add({
                          'label': 'Diskon 1',
                          'value': pilihBarang!.jualDisc1
                        });
                      }
                      if (pilihBarang!.jualDisc2 != null &&
                          pilihBarang!.jualDisc2 != 0) {
                        discs.add({
                          'label': 'Diskon 2',
                          'value': pilihBarang!.jualDisc2
                        });
                      }
                      if (pilihBarang!.jualDisc3 != null &&
                          pilihBarang!.jualDisc3 != 0) {
                        discs.add({
                          'label': 'Diskon 3',
                          'value': pilihBarang!.jualDisc3
                        });
                      }
                      if (pilihBarang!.jualDisc4 != null &&
                          pilihBarang!.jualDisc4 != 0) {
                        discs.add({
                          'label': 'Diskon 4',
                          'value': pilihBarang!.jualDisc4
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
                      jualdiscCtrl.text = suggestion['value'].toString();
                    },
                    noItemsFoundBuilder: (context) =>
                        Text('Diskon tidak tersedia'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: jumlahCtrl,
                    decoration: InputDecoration(
                      labelText: 'Jumlah jual',
                      border: OutlineInputBorder(), // border tegas
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    onFieldSubmitted: (_) => _handleSimpan(),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi tidak boleh kosong'
                        : null,
                  ),
                ),
              ],
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

  Future<void> prosesSimpan() async {
    final nofaktur = _nofakturController.text;
    final kdpelanggan = kodepelanggan;
    final namapelanggan = (_pelangganController.text?.trim().isEmpty ?? true)
        ? 'umum'
        : _pelangganController.text.trim();
    final tanggalpenjualan = tanggaljual;
    final namadoctor =
        _doctorController.text.isEmpty ? ' ' : _doctorController.text;
    final kddoctor = kodeDoctor;

    if (nofaktur.isEmpty || tanggalpenjualan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lengkapi semua data')),
      );
      return;
    }
    final data = {
      'noFaktur': nofaktur,
      'noResep': '',
      'kodePelanggan': kdpelanggan,
      'namaPelanggan': namapelanggan,
      'kodeDoctor': kddoctor,
      'namaDoctor': namadoctor,
      'tanggalPenjualan': tanggaljual!.toIso8601String(),
    };

    try {
      final bolehLanjut =
          await ApiService.cekNoFakturPenjualanBelumAda(nofaktur);

      if (!bolehLanjut) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No Faktur sudah digunakan')),
          );
        }
        return;
      }
      late http.Response response;
      response = await ApiService.pindahPenjualan(data, widget.user.username);

      if (!mounted) return; // <-- ini cek awal, sebelum lanjut
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data penjualan berhasil disimpan')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        await ApiService.logActivity(
            widget.user.id, 'Menambahkan Penjualan ${nofaktur}');
        // Reset form input
        _pelangganController.clear();
        kodepelanggan = ' ';
        _pelangganController.clear();
        _doctorController.clear();
        kodeDoctor = ' ';
        tanggaljual = DateTime.now();

        // Refresh tampilan
        _loadPenjualan();
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
                  '📦 Penjualan',
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
            Text(
              '${formatCurrency.format(totalpenjualan ?? 0)} ',
              style: TextStyle(fontSize: 30),
            ),
            Divider(
              thickness: 0.7,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TextFormField(
                      controller: _nofakturController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'No Faktur',
                      ),
                      readOnly: true,
                    ),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TextFormField(
                      controller: tanggaljualCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Penjualan',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // hilangkan keyboard
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tanggaljual ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          tanggaljual = picked;
                          tanggaljualCtrl.text = picked
                              .toIso8601String()
                              .split('T')
                              .first; // format ke yyyy-MM-dd
                        }
                      },
                    ),
                  ),
                ]),
                SizedBox(width: 200),
                Row(children: [
                  Checkbox(
                      value: iscekpelanggan,
                      onChanged: (bool? newvalue) {
                        setState(() {
                          iscekpelanggan = newvalue ?? false;
                          iscekumum = false;
                        });
                      }),
                  const Text('Pelanggan'),
                  Checkbox(
                      value: iscekumum,
                      onChanged: (bool? newvalue) {
                        setState(() {
                          iscekumum = newvalue ?? true;
                          iscekpelanggan = false;
                          if (iscekumum == true) {
                            _pelangganController.clear();
                          }
                        });
                      }),
                  const Text('Umum'),
                  SizedBox(width: 10),
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
                          enabled: iscekpelanggan),
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
                        kodepelanggan = suggestion.kodePelanggan;
                      },
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                        controller: _doctorController,
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            kodeDoctor = '';
                            // Kalau perlu trigger UI refresh
                            setState(() {});
                          }
                        }),
                    suggestionsCallback: (pattern) async {
                      try {
                        final response = await ApiService.searchDoctor(pattern);
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
                      _doctorController.text = suggestion.namaDoctor;
                      kodeDoctor = suggestion.kodeDoctor;
                    },
                  ),
                ),
              ],
            ),
            Divider(thickness: 0.7),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    height: 35,
                    width: 250,
                    child: TypeAheadField<BarangModel>(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(),
                          labelText: 'Masukan barang ke penjualan',
                        ),
                        controller: _barangController,
                        focusNode: _barangFocusNode,
                        onChanged: (value) {
                          if (!_isSelectingSuggestion) {
                            sisaStok = 0;
                            _jumlahbarangController.clear();
                            _discController.clear();
                            selectedBarang = null;
                            setState(() {
                              keterangan = null;
                            });
                          }
                        },
                        maxLines: 1,
                        // Tambahkan style untuk overflow di textfield supaya teks panjang tidak melebar
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      suggestionsCallback: (pattern) async {
                        try {
                          final response =
                              await ApiService.searchBarang(pattern);
                          return response
                              .map<BarangModel>(
                                  (json) => BarangModel.fromJson(json))
                              .toList();
                        } catch (e) {
                          return [];
                        }
                      },
                      itemBuilder: (context, BarangModel suggestion) {
                        // Gunakan Text dengan overflow dan maxLines agar text panjang tidak error
                        return ListTile(
                          title: Text(
                            suggestion.namaBarang ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'Kode: ${suggestion.kodeBarang} || Rak: ${suggestion.noRak}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                      onSuggestionSelected: (BarangModel suggestion) async {
                        _barangController.text = suggestion.namaBarang ?? '';
                        kodebarang = suggestion.kodeBarang;
                        kelompok = suggestion.kelompok ?? '';
                        satuan = suggestion.satuan ?? '';
                        sisaStok = suggestion.stokAktual;
                        hargabeli = suggestion.hargaBeli;
                        hargajual = suggestion.hargaJual;
                        keterangan = suggestion.keterangan;
                        _jumlahbeliFocusNode.requestFocus();
                        selectedBarang =
                            await ApiService.fetchBarangByKodefodiscon(
                                kodebarang);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _isSelectingSuggestion = false;
                        });
                        setState(() {});
                      },
                    ),
                  ),
                ]),
                SizedBox(width: 15),
                SizedBox(
                  height: 35,
                  width: 75,
                  child: TextFormField(
                    controller: _jumlahbarangController,
                    focusNode: _jumlahbeliFocusNode,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: 'Jumlah',
                    ),
                    onFieldSubmitted: (_) => ProsesPenjualan(),
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  height: 35,
                  width: 150,
                  child: TypeAheadFormField<Map<String, dynamic>>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _discController,
                      focusNode: _discFocusNode,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'Jual Diskon',
                      ),
                      onSubmitted: (_) => ProsesPenjualan(),
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
                  onPressed: ProsesPenjualan,
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
                ),
                SizedBox(
                  width: 10,
                ),
                if (keterangan != null) ...[
                  Tooltip(
                    message: keterangan!.trim().isNotEmpty
                        ? keterangan!
                        : 'Tidak ada keterangan',
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    preferBelow: false,
                    waitDuration: const Duration(milliseconds: 300),
                    showDuration: const Duration(seconds: 5),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 15),
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
                    headingTextStyle: const TextStyle(fontSize: 12),
                    columnSpacing: 10,
                    dataTextStyle: const TextStyle(fontSize: 11),
                    columns: const [
                      DataColumn(label: Text('Kode')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Kelompok')),
                      DataColumn(label: Text('Satuan')),
                      DataColumn(label: Text('Harga Jual')),
                      DataColumn(label: Text('Jual Disc')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Total stlh disc')),
                      DataColumn(label: Text('Total Disc')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: allPenjualantmp.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(Text(p.kodeBarang)),
                          DataCell(SizedBox(
                              width: 200,
                              child: Text(
                                p.namaBarang,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ))),
                          DataCell(Text(p.kelompok)),
                          DataCell(Text(p.satuan)),
                          DataCell(Text(formatCurrency.format(p.hargaJual))),
                          DataCell(Text(formatCurrency.format(p.jualDiscon))),
                          DataCell(Text((p.jumlahJual ?? 0).toString())),
                          DataCell(Text(
                              formatCurrency.format(p.totalHargaSebelumDisc))),
                          DataCell(Text(formatCurrency
                              .format(p.totalHargaSetelahDisc ?? 0))),
                          DataCell(Text(formatCurrency.format(p.totalDisc))),
                          DataCell(Row(
                            children: [
                              IconButton(
                                tooltip: 'Edit Data',
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showForm(penjualanstmp: p),
                              ),
                              IconButton(
                                tooltip: 'Hapus Data',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deletepenjualantmp(p.id.toString()),
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
