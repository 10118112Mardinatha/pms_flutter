import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PenjualanScreen extends StatefulWidget {
  final AppDatabase database;

  const PenjualanScreen({super.key, required this.database});

  @override
  State<PenjualanScreen> createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  late AppDatabase db;
  List<PenjualanstmpData> allPenjualantmp = [];
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
  TextEditingController _expiredController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final formatCurrency =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  DateTime? tgexpired;
  String kodeDoctor = ' ';
  Barang? selectedBarang;
  String totalpenjualan = '';
  String kodebarang = '';
  int idstok = 0;
  int sisaStok = 0;
  String kodepelanggan = ' ';
  String satuan = '';
  String kelompok = '';
  int hargabeli = 0;
  int hargajual = 0;
  int jualdiscon = 0;
  int jumlahjual = 0;
  int totalharga = 0;
  int totalhargastlhdiskon = 0;
  int totaldiskon = 0;

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadPenjualan();
  }

  Future<void> _loadPenjualan() async {
    final data = await db.getAllPenjualansTmp();
    tanggaljualCtrl.text = DateTime.now().toIso8601String().split('T').first;
    generateNoFakturPenjualan(db, _nofakturController);
    setState(() {
      allPenjualantmp = data;
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

  Future<void> generateNoFakturPenjualan(
      AppDatabase db, TextEditingController noFakturController) async {
    int counter = 1;
    String newNoFaktur;

    while (true) {
      newNoFaktur = 'PJ${counter.toString().padLeft(5, '0')}';

      final query = db.select(db.penjualans)
        ..where((tbl) => tbl.noFaktur.equals(newNoFaktur));

      final results = await query.get();

      if (results.isEmpty) {
        break; // NoFaktur unik
      }
      counter++;
    }

    noFakturController.text = newNoFaktur;
  }

  Future<void> ProsesPenjualan() async {
    String namabarang = _barangController.text;
    jumlahjual = int.tryParse(_jumlahbarangController.text) ?? 0;
    int jualdiscon = int.tryParse(_discController.text) ?? hargajual;
    totalharga = (hargajual * jumlahjual);
    totalhargastlhdiskon = (jualdiscon * jumlahjual);
    totaldiskon = totalharga - totalhargastlhdiskon;
    final tanggalexpired = tgexpired;
    final id = idstok;
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
      await db.insertPenjualanTmp(PenjualanstmpCompanion(
        kodeBarang: Value(kodebarang),
        namaBarang: Value(_barangController.text),
        idStok: Value(id),
        expired:
            Value(tanggalexpired ?? DateTime.now()), // fallback jika kosong
        kelompok: Value(kelompok),
        satuan: Value(satuan),
        hargaBeli: Value(hargabeli),
        hargaJual: Value(hargajual),
        jualDiscon: Value(jualdiscon),
        jumlahJual: Value(jumlahjual),
        totalHargaSebelumDisc: Value(totalharga),
        totalHargaSetelahDisc: Value(totalhargastlhdiskon),
        totalDisc: Value(totaldiskon),
      ));
    }

    _barangController.clear();
    _discController.clear();
    tgexpired = null;
    _jumlahbarangController.clear();
    _expiredController.clear;
    _loadPenjualan();
  }

  Future<void> updateTotalSeluruh() async {
    final total = await db.getTotalHargaSetelahDiscPenjualanTmp();
    totalpenjualan = total == 0 ? '' : '${total.toString()}';
  }

  Future<void> prosesbatal() async {
    // Bersihkan tabel pembelianstmp
    await db.delete(db.penjualanstmp).go();

    // Reset form input
    _loadPenjualan();
    _doctorController.clear();
    kodeDoctor = '';
    kodepelanggan = '';
    _pelangganController.clear();
  }

  void _deletepenjualantmp(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus'),
        content: const Text('Yakin ingin menghapus data ini?'),
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
      await db.deletePenjualanTmp(id);
      await _loadPenjualan(); // <-- refresh data di layar
    }
  }

  Future<void> _showForm({PenjualanstmpData? penjualanstmp}) async {
    final formKey = GlobalKey<FormState>();
    final kodebarangCtrl =
        TextEditingController(text: penjualanstmp?.kodeBarang ?? '');
    final namabarangCtrl =
        TextEditingController(text: penjualanstmp?.namaBarang ?? '');

    final jualdiscCtrl = TextEditingController(
        text: penjualanstmp?.jualDiscon?.toString() ?? '');
    final jumlahCtrl =
        TextEditingController(text: penjualanstmp?.jumlahJual.toString() ?? '');

    Barang? pilihBarang = await db.getBarangByKode(kodebarangCtrl.text);
    int idstokupdate = 0;
    int sisaStokupdate = 0;

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
                TextFormField(
                  controller: kodebarangCtrl,
                  decoration: InputDecoration(labelText: 'Kode barang'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: namabarangCtrl,
                  decoration: InputDecoration(labelText: 'Nama '),
                  readOnly: true,
                ),
                TypeAheadFormField<Map<String, dynamic>>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: jualdiscCtrl,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Jual Diskon',
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
                if (penjualanstmp != null) {
                  int jumlah = pilihBarang?.stokAktual ?? 0;
                  if (jumlah != null &&
                      sisaStokupdate != null &&
                      jumlah! > sisaStokupdate!) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Stok Tidak Cukup'),
                        content: Text(
                            'Stok tersedia hanya $sisaStokupdate, tetapi jumlah jual $jumlah.'),
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
                  await db.updatePenjualanTmp(
                    penjualanstmp.copyWith(
                        kodeBarang: kodebarangCtrl.text,
                        namaBarang: namabarangCtrl.text,
                        idStok: Value(idstokupdate),
                        jualDiscon: Value(int.tryParse(jualdiscCtrl.text)),
                        jumlahJual: Value(int.tryParse(jumlahCtrl.text))),
                  );
                }
                if (context.mounted) Navigator.pop(context);
                await _loadPenjualan();
              }
            },
            child: const Text('Simpan'),
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

    final items = await db.getAllPenjualansTmp();

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada data yang akan diproses')),
      );
      return;
    }

    // Gunakan batch untuk insert semua data ke tabel pembelians
    await db.batch((batch) {
      batch.insertAll(
        db.penjualans,
        items
            .map((item) => PenjualansCompanion(
                noFaktur: Value(nofaktur),
                kodePelanggan: Value(kdpelanggan),
                namaPelanggan: Value(namapelanggan),
                kodeDoctor: Value(kddoctor),
                namaDoctor: Value(namadoctor),
                tanggalPenjualan: Value(tanggalpenjualan),
                kodeBarang: Value(item.kodeBarang),
                namaBarang: Value(item.namaBarang),
                expired: Value(item.expired!),
                kelompok: Value(item.kelompok),
                satuan: Value(item.satuan),
                hargaBeli: Value(item.hargaBeli),
                hargaJual: Value(item.hargaJual),
                jualDiscon: Value(item.jualDiscon),
                jumlahJual: Value(item.jumlahJual),
                totalHargaSebelumDisc: Value(item.totalHargaSebelumDisc),
                totalHargaSetelahDisc: Value(item.totalHargaSetelahDisc),
                totalDisc: Value(item.totalDisc)))
            .toList(),
      );
      // Update stok di tabel barangs
      for (final item in items) {
        batch.customStatement(
          '''
        UPDATE barangs
        SET stok_aktual = stok_aktual - ?
        WHERE kode_barang = ?
        ''',
          [
            item.jumlahJual ?? 0,
            item.kodeBarang,
          ],
        );
      }
    });

    // Bersihkan tabel pembelianstmp
    await db.delete(db.penjualanstmp).go();

    // Reset form input
    _pelangganController.clear();
    kodepelanggan = ' ';
    _pelangganController.clear();
    _doctorController.clear();
    kodeDoctor = ' ';
    tanggaljual = DateTime.now();

    // Refresh tampilan
    _loadPenjualan();

    // Notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data penjualan berhasil diproses.')),
    );
  }

  void _handleSimpanPenjualan() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Simpan Penjualan'),
        content: Text('Apakah Anda ingin mencetak struk setelah menyimpan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'batal'),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'simpan'),
            child: Text('Simpan Saja'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'simpan_cetak'),
            child: Text('Simpan dan Cetak'),
          ),
        ],
      ),
    );

    if (result == 'batal') return;

    // Simpan data ke database
    await prosesSimpan(); // Pastikan proses ini menyimpan transaksi & detailnya

    // Ambil data penjualan terakhir berdasarkan no faktur
    final items = await db.getLastPenjualanByNoFaktur(_nofakturController.text);

    if (result == 'simpan_cetak') {
      _showStrukPreview(items);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Penjualan berhasil disimpan.')),
      );
    }
  }

  void _showStrukPreview(List<Penjualan> items) {
    final totalSebelum = items.fold<double>(
        0, (sum, item) => sum + (item.totalHargaSebelumDisc ?? 0));
    final totalDiskon =
        items.fold<int>(0, (sum, item) => sum + (item.jualDiscon ?? 0));
    final totalBayar = items.fold<double>(
        0, (sum, item) => sum + (item.totalHargaSetelahDisc ?? 0));

    final now = DateTime.now();
    final formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Preview Struk'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: const [
                      Text('Apotek Segar 2',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Jl. Temanggung Tilung No.XII, Menteng,'),
                      Text('Kec. Jekan Raya Kota Palangka Raya'),
                      Text('Kalimantan Tengah'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('No Faktur : ${_nofakturController.text}'),
                Text('Tanggal   : $formattedDateTime'),
                const Divider(),
                ...items.asMap().entries.map((entry) {
                  final i = entry.key + 1;
                  final item = entry.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('$i. ${item.namaBarang}')),
                      Text('${item.satuan}    |   x${item.jumlahJual}'),
                    ],
                  );
                }),
                const Divider(),
                Text(
                    'Total Harga          : Rp ${totalSebelum.toStringAsFixed(0)}'),
                Text('Total Diskon         : Rp $totalDiskon'),
                Text(
                    'Total Dibayar        : Rp ${totalBayar.toStringAsFixed(0)}'),
                const SizedBox(height: 10),
                const Divider(),
                const Center(
                  child: Text(
                    'Terima kasih atas kunjungannya',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _printStruk(items);
            },
            child: const Text('Cetak'),
          ),
        ],
      ),
    );
  }

  Future<void> _printStruk(List<Penjualan> items) async {
    final doc = pw.Document();

    final totalSebelum = items.fold<double>(
        0, (sum, item) => sum + (item.totalHargaSebelumDisc ?? 0));
    final totalDiskon =
        items.fold<int>(0, (sum, item) => sum + (item.jualDiscon ?? 0));
    final totalBayar = items.fold<double>(
        0, (sum, item) => sum + (item.totalHargaSetelahDisc ?? 0));

    final now = DateTime.now();
    final formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Apotek Segar 2',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Jl. Temanggung Tilung No.XII, Menteng,'),
                    pw.Text('Kec. Jekan Raya Kota Palangka Raya'),
                    pw.Text('Kalimantan Tengah'),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('No Faktur : ${_nofakturController.text}'),
              pw.Text('Tanggal   : $formattedDateTime'),
              pw.Divider(),
              ...items.asMap().entries.map((entry) {
                final i = entry.key + 1;
                final item = entry.value;
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text('$i. ${item.namaBarang}')),
                    pw.Text('${item.satuan}    |   x${item.jumlahJual}'),
                  ],
                );
              }),
              pw.Divider(),
              pw.Text(
                  'Total Harga          : Rp ${totalSebelum.toStringAsFixed(0)}'),
              pw.Text('Total Diskon         : Rp $totalDiskon'),
              pw.Text(
                  'Total Dibayar         : Rp ${totalBayar.toStringAsFixed(0)}'),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'Terima kasih atas kunjungannya',
                  style: pw.TextStyle(
                      fontSize: 10, fontStyle: pw.FontStyle.italic),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Struk Penjualan',
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
                  'Penjualan',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                Row(children: [
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
                    onPressed: _handleSimpanPenjualan,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan/Bayar'),
                  ),
                ])
              ],
            ),
            Divider(
              thickness: 0.7,
            ),
            Text(
              'Rp.${totalpenjualan} ',
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
                        labelText: 'Tanggal Pembelian',
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
                    child: TypeAheadField<Pelanggan>(
                      textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            border: OutlineInputBorder(),
                            labelText: 'Kode/Nama Pelanggan',
                          ),
                          controller: _pelangganController,
                          enabled: iscekpelanggan),
                      suggestionsCallback: (pattern) async {
                        return await db.searchPelanggan(
                            pattern); // db adalah instance AppDatabase
                      },
                      itemBuilder: (context, Pelanggan suggestion) {
                        return ListTile(
                          title: Text(suggestion.namaPelanggan),
                          subtitle: Text('Kode: ${suggestion.kodPelanggan}'),
                        );
                      },
                      onSuggestionSelected: (Pelanggan suggestion) {
                        _pelangganController.text = suggestion.namaPelanggan;
                        kodepelanggan = suggestion.kodPelanggan;
                      },
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Checkbox(
                    value: iscekresep,
                    onChanged: (bool? newvalue) async {
                      setState(() {
                        iscekresep = newvalue ?? false;
                      });

                      if (iscekresep && kodepelanggan.isNotEmpty) {
                        // Ambil resep dari DB
                        final resepList =
                            await db.getResepByKodePelanggan(kodepelanggan);

                        // Masukkan ke Penjualanstmp
                        for (final resep in resepList) {
                          await db.insertPenjualanTmp(PenjualanstmpCompanion(
                            kodeBarang: Value(resep.kodeBarang),
                            namaBarang: Value(resep
                                .namaBarang), // Gunakan expired default sementara
                            kelompok: Value(resep.kelompok),
                            satuan: Value(resep.satuan),
                            hargaBeli: Value(resep.hargaBeli),
                            hargaJual: Value(resep.hargaJual),
                            jualDiscon: Value(resep.jualDiscon),
                            jumlahJual: Value(resep.jumlahJual),
                            totalHargaSebelumDisc:
                                Value(resep.totalHargaSebelumDisc),
                            totalHargaSetelahDisc:
                                Value(resep.totalHargaSetelahDisc),
                            totalDisc: Value(resep.totalDisc),
                          ));
                          _doctorController.text = resep.namaDoctor;
                          kodeDoctor = resep.kodeDoctor!;
                        }
                        // Trigger UI refresh jika perlu
                        _loadPenjualan(); // Refresh data
                        setState(() {});
                      }
                    },
                  ),
                  const Text('Resep'),
                ]),
                SizedBox(
                  height: 35,
                  width: 200,
                  child: TypeAheadField<Doctor>(
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
                      return await db.searcDoctor(
                          pattern); // db adalah instance AppDatabase
                    },
                    itemBuilder: (context, Doctor suggestion) {
                      return ListTile(
                        title: Text(suggestion.namaDoctor),
                        subtitle: Text('Kode: ${suggestion.kodeDoctor}'),
                      );
                    },
                    onSuggestionSelected: (Doctor suggestion) {
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
                SizedBox(
                  height: 35,
                  width: 250,
                  child: TypeAheadField<Barang>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'Tambah barang',
                      ),
                      controller: _barangController,
                    ),
                    suggestionsCallback: (pattern) async {
                      return await db.searchBarang(
                          pattern); // db adalah instance AppDatabase
                    },
                    itemBuilder: (context, Barang suggestion) {
                      return ListTile(
                        title: Text(suggestion.namaBarang),
                        subtitle: Text(
                            'Kode: ${suggestion.kodeBarang}|| Rak : ${suggestion.noRak}'),
                      );
                    },
                    onSuggestionSelected: (Barang suggestion) async {
                      _barangController.text = suggestion.namaBarang;
                      kodebarang = suggestion.kodeBarang;
                      kelompok = suggestion.kelompok;
                      satuan = suggestion.satuan;
                      sisaStok = suggestion.stokAktual;
                      hargabeli = suggestion.hargaBeli;
                      hargajual = suggestion.hargaJual;
                      selectedBarang = await db.getBarangByKode(kodebarang);
                      // Ambil expired paling tua

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
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  height: 35,
                  width: 150,
                  child: TypeAheadFormField<Map<String, dynamic>>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _discController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'Jual Diskon',
                      ),
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
                      return ListTile(
                        title: Text(suggestion['value'].toString()),
                        subtitle: Text(suggestion['label']),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _discController.text = suggestion['value'].toString();
                    },
                    noItemsFoundBuilder: (context) =>
                        Text('Diskon tidak tersedia'),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton.icon(
                  onPressed: ProsesPenjualan,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
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
                          DataCell(Text(p.namaBarang)),
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
                                onPressed: () => _deletepenjualantmp(p.id),
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
