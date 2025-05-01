import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class ResepScreen extends StatefulWidget {
  final AppDatabase database;

  const ResepScreen({super.key, required this.database});

  @override
  State<ResepScreen> createState() => _ResepScreenState();
}

class _ResepScreenState extends State<ResepScreen> {
  late AppDatabase db;
  List<ResepstmpData> allReseptmp = [];
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
  Barang? selectedBarang;

//formutama
  String kodedokter = '';
  String kodePelanggan = '';

//buat tmp
  String kodebarang = '';
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
    _loadResep();
  }

  Future<void> _loadResep() async {
    tanggalCtrl.text = DateTime.now().toIso8601String().split('T').first;
    generateNoResep(db, _noResepController);
    final data = await db.getAllResepsTmp();
    setState(() {
      allReseptmp = data;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> generateNoResep(
      AppDatabase db, TextEditingController noResepController) async {
    int counter = 1;
    String newNoResep;

    while (true) {
      newNoResep = 'RS${counter.toString().padLeft(5, '0')}'; // Contoh: RS00001

      final query = db.select(db.reseps)
        ..where((tbl) => tbl.noResep.equals(newNoResep));

      final exists = await query.getSingleOrNull();

      if (exists == null) {
        break; // NoResep unik
      }

      counter++;
    }

    noResepController.text = newNoResep;
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

    final items = await db.getAllResepsTmp();

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada data yang akan diproses')),
      );
      return;
    }

    // Gunakan batch untuk insert semua data ke tabel pembelians
    await db.batch((batch) {
      batch.insertAll(
        db.reseps,
        items
            .map((item) => ResepsCompanion(
                noResep: Value(noresep),
                tanggal: Value(tanggalresep),
                kodePelanggan: Value(kdpelanggan),
                namaPelanggan: Value(namapelanggan),
                kelompokPelanggan: Value(kelompokpelanggan),
                kodeDoctor: Value(kddoctor),
                namaDoctor: Value(namadoctor),
                usia: Value(umur),
                alamat: Value(alamat),
                keterangan: Value(keterangan),
                noTelp: Value(nohp),
                kodeBarang: Value(item.kodeBarang),
                namaBarang: Value(item.namaBarang),
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
    });

    // Bersihkan tabel pembelianstmp
    await db.delete(db.resepstmp).go();

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
    // Refresh tampilan
    _loadResep();

    // Notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data pembelian berhasil diproses.')),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> ProsesTambahresep() async {
    String namabarang = _barangController.text;
    jumlahjual = int.tryParse(_jumlahbarangController.text) ?? 0;
    totalharga = (hargajual * jumlahjual);
    totalhargastlhdiskon = totalharga - jualdiscon;
    totaldiskon = totalharga - totalhargastlhdiskon;

    if (namabarang != '') {
      await db.insertResepsTmp(ResepstmpCompanion(
          kodeBarang: Value(kodebarang),
          namaBarang: Value(_barangController.text),
          kelompok: Value(kelompok),
          satuan: Value(satuan),
          hargaBeli: Value(hargabeli),
          hargaJual: Value(hargajual),
          jualDiscon: Value(jualdiscon),
          jumlahJual: Value(jumlahjual),
          totalHargaSebelumDisc: Value(totalharga),
          totalHargaSetelahDisc: Value(totalhargastlhdiskon),
          totalDisc: Value(totaldiskon)));
    }
    _barangController.clear();
    _jumlahbarangController.clear();
    _loadResep();
  }

  void _deleteResep(int id) async {
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
      await db.deleteResepTmp(id);
      await _loadResep(); // <-- refresh data di layar
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
                  'Resep',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                Row(children: [
                  ElevatedButton.icon(
                    onPressed: _loadResep,
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
                    child: TypeAheadField<Doctor>(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(),
                          labelText: 'Kode/Nama Dokter',
                        ),
                        controller: _namaDoctorController,
                      ),
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
                  child: TypeAheadField<Pelanggan>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'Kode/Nama Pelanggan',
                      ),
                      controller: _pelangganController,
                    ),
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
                      kodePelanggan = suggestion.kodPelanggan;
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
                  child: TypeAheadField<Barang>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'Tambah barang ke resep',
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
                  onPressed: ProsesTambahresep,
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
                      DataColumn(label: Text('Harga beli')),
                      DataColumn(label: Text('Harga Jual')),
                      DataColumn(label: Text('Jual Disc')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Total stlh disc')),
                      DataColumn(label: Text('Total Disc')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: allReseptmp.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(Text(p.kodeBarang)),
                          DataCell(Text(p.namaBarang)),
                          DataCell(Text(p.kelompok)),
                          DataCell(Text(p.satuan)),
                          DataCell(Text(p.hargaBeli.toString())),
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
                                onPressed: () => _deleteResep(p.id),
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
