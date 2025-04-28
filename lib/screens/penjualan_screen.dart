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

class PenjualanScreen extends StatefulWidget {
  final AppDatabase database;

  const PenjualanScreen({super.key, required this.database});

  @override
  State<PenjualanScreen> createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  late AppDatabase db;
  List<Penjualan> allPenjualan = [];
  bool iscekumum = true;
  bool iscekpelanggan = false;
  bool iscekresep = false;
  final tanggaljualCtrl = TextEditingController(); // definisikan di atas
  DateTime? tanggaljual;
  final TextEditingController _barangController = TextEditingController();
  final TextEditingController _pelangganController = TextEditingController();
  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadPenjualan();
    tanggaljualCtrl.text = DateTime.now().toIso8601String().split('T').first;
  }

  Future<void> _loadPenjualan() async {
    final data = await db.getAllPenjualans();
    setState(() {
      allPenjualan = data;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> ProsesPenjualan() async {
    return;
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
                    onPressed: ProsesPenjualan,
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
                    onPressed: ProsesPenjualan,
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
              'Rp. ',
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
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'No Faktur',
                      ),
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
                    onSuggestionSelected: (Barang suggestion) {
                      _barangController.text = suggestion.namaBarang;
                    },
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  height: 35,
                  width: 75,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: 'Jumlah',
                    ),
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
                      DataColumn(label: Text('Expired')),
                      DataColumn(label: Text('Kelompok')),
                      DataColumn(label: Text('Satuan')),
                      DataColumn(label: Text('Harga Jual')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: [],
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
