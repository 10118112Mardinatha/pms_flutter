import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class TestlaporanScreen extends StatefulWidget {
  final AppDatabase database;

  const TestlaporanScreen({super.key, required this.database});

  @override
  State<TestlaporanScreen> createState() => _TestlaporanScreenState();
}

class _TestlaporanScreenState extends State<TestlaporanScreen> {
  late AppDatabase db;
  List<Resep> allPembelian = [];

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadBarangs();
  }

  Future<void> _loadBarangs() async {
    final data = await db.getAllReseps();
    setState(() {
      allPembelian = data;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all(Colors.blue.shade100),
                    dataRowColor: MaterialStateProperty.all(Colors.white),
                    border: TableBorder.all(color: Colors.grey.shade300),
                    headingRowHeight: 50,
                    headingTextStyle: const TextStyle(fontSize: 12),
                    columnSpacing: 20,
                    dataTextStyle: const TextStyle(fontSize: 11),
                    columns: const [
                      DataColumn(label: Text('no resep')),
                      DataColumn(label: Text('pelanggan')),
                      DataColumn(label: Text('doctor')),
                      DataColumn(label: Text('tanngal resep')),
                      DataColumn(label: Text('barang')),
                      DataColumn(label: Text('Kelompok')),
                      DataColumn(label: Text('Satuan')),
                      DataColumn(label: Text('Harga Beli')),
                      DataColumn(label: Text('Harga Jual')),
                    ],
                    rows: allPembelian.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(Text((p.noResep ?? 0).toString())),
                          DataCell(Text(p.namaPelanggan)),
                          DataCell(Text(p.namaDoctor)),
                          DataCell(Text(formatDate(
                              DateTime.parse(p.tanggal.toString())))),
                          DataCell(Text(p.namaBarang)),
                          DataCell(Text(p.kelompok)),
                          DataCell(Text(p.satuan)),
                          DataCell(Text(p.hargaBeli.toString())),
                          DataCell(Text(p.hargaJual.toString())),
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
