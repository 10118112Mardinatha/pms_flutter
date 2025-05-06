import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:collection/collection.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class StokScreen extends StatefulWidget {
  final AppDatabase database;

  const StokScreen({super.key, required this.database});

  @override
  State<StokScreen> createState() => _StokScreenState();
}

class _StokScreenState extends State<StokScreen> {
  late AppDatabase db;
  List<Stok> allStok = [];
  List<Barang> filteredBarangs = [];
  String searchField = 'Nama Barang';
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final searchOptions = [
    'Kode Barang',
    'Nama Barang',
    'Kelompok',
    'Satuan',
  ];
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadBarangs();
  }

  Future<void> _loadBarangs() async {
    final data = await db.getAllStok();
    setState(() {
      allStok = data;
    });
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
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all(Colors.blue.shade100),
                    dataRowColor: MaterialStateProperty.all(Colors.white),
                    border: TableBorder.all(color: Colors.grey.shade300),
                    headingRowHeight: 50,
                    headingTextStyle: const TextStyle(fontSize: 11),
                    columnSpacing: 20,
                    dataTextStyle: const TextStyle(fontSize: 13),
                    columns: const [
                      DataColumn(label: Text('Id')),
                      DataColumn(label: Text('Kode Barang')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('ex')),
                      DataColumn(label: Text('stok')),
                    ],
                    rows: allStok.map((stok) {
                      return DataRow(cells: [
                        DataCell(Text(stok.idStok.toString())),
                        DataCell(Text(stok.kodeBarang)),
                        DataCell(Text(stok.namaBarang)),
                        DataCell(Text(
                            DateFormat('dd-MM-yyyy').format(stok.expired))),
                        DataCell(Text(stok.stok.toString())),
                      ]);
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
