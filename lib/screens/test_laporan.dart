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
  List<Pembelian> allPembelian = [];

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadBarangs();
  }

  Future<void> _loadBarangs() async {
    final data = await db.getAllPembelians();
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
                      DataColumn(label: Text('faktur')),
                      DataColumn(label: Text('Kode')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('barang')),
                      DataColumn(label: Text('Expired')),
                      DataColumn(label: Text('Kelompok')),
                      DataColumn(label: Text('Satuan')),
                      DataColumn(label: Text('Harga Beli')),
                      DataColumn(label: Text('Harga Jual')),
                      DataColumn(label: Text('Disc1')),
                      DataColumn(label: Text('Disc2')),
                      DataColumn(label: Text('Disc3')),
                      DataColumn(label: Text('Disc4')),
                      DataColumn(label: Text('PPN')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Total')),
                    ],
                    rows: allPembelian.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(Text((p.noFaktur ?? 0).toString())),
                          DataCell(Text(p.kodeSupplier)),
                          DataCell(Text(p.namaSuppliers)),
                          DataCell(Text(p.namaBarang)),
                          DataCell(Text(formatDate(
                              DateTime.parse(p.expired.toString())))),
                          DataCell(Text(p.kelompok)),
                          DataCell(Text(p.satuan)),
                          DataCell(Text(p.hargaBeli.toString())),
                          DataCell(Text(p.hargaJual.toString())),
                          DataCell(Text((p.jualDisc1 ?? 0).toString())),
                          DataCell(Text((p.jualDisc2 ?? 0).toString())),
                          DataCell(Text((p.jualDisc3 ?? 0).toString())),
                          DataCell(Text((p.jualDisc4 ?? 0).toString())),
                          DataCell(Text((p.ppn ?? 0).toString())),
                          DataCell(Text((p.jumlahBeli ?? 0).toString())),
                          DataCell(Text((p.totalHarga ?? 0).toString())),
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
