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
  Barang? selectedBarang;
  String totalpenjualan = '';
  String kodebarang = '';

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

      final exists = await query.getSingleOrNull();

      if (exists == null) {
        break; // NoResep unik
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

    if (namabarang != '') {
      // Ambil tanggal expired paling tua dari Penjualans berdasarkan kodeBarang
      final expiredTertua = await (db.select(db.penjualans)
            ..where((tbl) => tbl.kodeBarang.equals(kodebarang))
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.expired)]))
          .map((row) => row.expired)
          .getSingleOrNull();

      await db.insertPenjualanTmp(PenjualanstmpCompanion(
        kodeBarang: Value(kodebarang),
        namaBarang: Value(_barangController.text),
        expired: Value(expiredTertua ?? DateTime.now()), // fallback jika kosong
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
    _jumlahbarangController.clear();
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

  Future<void> prosesSimpan() async {
    final nofaktur = _nofakturController.text;
    final kdpelanggan = kodepelanggan;
    final namapelanggan = (_pelangganController.text?.trim().isEmpty ?? true)
        ? 'umum'
        : _pelangganController.text.trim();
    final tanggalpenjualan = tanggaljual;

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
                tanggalPenjualan: Value(tanggalpenjualan),
                kodeBarang: Value(item.kodeBarang),
                namaBarang: Value(item.namaBarang),
                expired: Value(item.expired),
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
    kodepelanggan = '';
    tanggaljual = DateTime.now();

    // Refresh tampilan
    _loadPenjualan();

    // Notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data penjualan berhasil diproses.')),
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
                    onPressed: prosesSimpan,
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
                    onChanged: (bool? newvalue) {
                      setState(() {
                        iscekresep = newvalue ?? false;
                      });
                    },
                  ),
                  const Text('Resep'),
                ]),
                SizedBox(
                  height: 35,
                  width: 200,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: 'Dokter',
                    ),
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
                        subtitle: Text('Kode: ${suggestion.kodeBarang}'),
                      );
                    },
                    onSuggestionSelected: (Barang suggestion) async {
                      _barangController.text = suggestion.namaBarang;
                      kodebarang = suggestion.kodeBarang;
                      kelompok = suggestion.kelompok;
                      satuan = suggestion.satuan;
                      hargabeli = suggestion.hargaBeli;
                      hargajual = suggestion.hargaJual;
                      selectedBarang = await db.getBarangByKode(kodebarang);
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
                  width: 250,
                  child: TypeAheadFormField<Map<String, dynamic>>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _discController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'Pilih Diskon',
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      if (selectedBarang == null) return [];

                      final discs = <Map<String, dynamic>>[];

                      if (selectedBarang!.jualDisc1 != null) {
                        discs.add({
                          'label': 'Diskon 1',
                          'value': selectedBarang!.jualDisc1
                        });
                      }
                      if (selectedBarang!.jualDisc2 != null) {
                        discs.add({
                          'label': 'Diskon 2',
                          'value': selectedBarang!.jualDisc2
                        });
                      }
                      if (selectedBarang!.jualDisc3 != null) {
                        discs.add({
                          'label': 'Diskon 3',
                          'value': selectedBarang!.jualDisc3
                        });
                      }
                      if (selectedBarang!.jualDisc4 != null) {
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
                      DataColumn(label: Text('Expired')),
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
                          DataCell(Text(formatDate(
                              DateTime.parse(p.expired.toString())))),
                          DataCell(Text(p.hargaJual.toString())),
                          DataCell(Text((p.jualDiscon ?? 0).toString())),
                          DataCell(Text((p.jumlahJual ?? 0).toString())),
                          DataCell(
                              Text((p.totalHargaSebelumDisc ?? 0).toString())),
                          DataCell(
                              Text((p.totalHargaSetelahDisc ?? 0).toString())),
                          DataCell(Text((p.totalDisc ?? 0).toString())),
                          DataCell(Row(
                            children: [
                              IconButton(
                                tooltip: 'Edit Data',
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => (data: p),
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
