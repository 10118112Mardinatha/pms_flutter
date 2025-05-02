import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../database/app_database.dart';

class TestlaporanScreen extends StatefulWidget {
  final AppDatabase database;

  const TestlaporanScreen({super.key, required this.database});

  @override
  State<TestlaporanScreen> createState() => _TestlaporanScreenState();
}

class _TestlaporanScreenState extends State<TestlaporanScreen> {
  late AppDatabase db;
  List<Resep> allResep = [];
  List<Resep> filteredResep = [];

  final TextEditingController searchController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await db.getAllReseps();
    setState(() {
      allResep = data;
      filteredResep = data;
    });
  }

  void _filterData() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredResep = allResep.where((item) {
        final matchesText = item.namaPelanggan.toLowerCase().contains(query) ||
            item.namaDoctor.toLowerCase().contains(query) ||
            item.namaBarang.toLowerCase().contains(query);

        final itemDate = DateTime.parse(item.tanggal.toString());
        final matchesDate = (startDate == null ||
                itemDate
                    .isAfter(startDate!.subtract(const Duration(days: 1)))) &&
            (endDate == null ||
                itemDate.isBefore(endDate!.add(const Duration(days: 1))));

        return matchesText && matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          startDateController.text = DateFormat('dd-MM-yyyy').format(picked);
        } else {
          endDate = picked;
          endDateController.text = DateFormat('dd-MM-yyyy').format(picked);
        }
        _filterData();
      });
    }
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Laporan Resep'];

    sheet.appendRow([
      'No Resep',
      'Pelanggan',
      'Doctor',
      'Tanggal Resep',
      'Barang',
      'Kelompok',
      'Satuan',
      'Harga Beli',
      'Harga Jual',
    ]);

    for (var item in filteredResep) {
      sheet.appendRow([
        item.noResep ?? '',
        item.namaPelanggan,
        item.namaDoctor,
        DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(item.tanggal.toString())),
        item.namaBarang,
        item.kelompok,
        item.satuan,
        item.hargaBeli,
        item.hargaJual,
      ]);
    }

    final bytes = excel.save()!;
    final file = File('${Directory.systemTemp.path}/laporan.xlsx');
    await file.writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File diexport ke: ${file.path}')));
  }

  Future<void> _printLaporan() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Table.fromTextArray(
          headers: [
            'No Resep',
            'Pelanggan',
            'Doctor',
            'Tanggal Resep',
            'Barang',
            'Kelompok',
            'Satuan',
            'Harga Beli',
            'Harga Jual'
          ],
          data: filteredResep.map((item) {
            return [
              item.noResep.toString(),
              item.namaPelanggan,
              item.namaDoctor,
              DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(item.tanggal.toString())),
              item.namaBarang,
              item.kelompok,
              item.satuan,
              currencyFormatter.format(item.hargaBeli),
              currencyFormatter.format(item.hargaJual),
            ];
          }).toList(),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final dataSource = ResepDataSource(filteredResep, currencyFormatter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Resep'),
        actions: [
          IconButton(icon: const Icon(Icons.print), onPressed: _printLaporan),
          IconButton(
              icon: const Icon(Icons.file_download), onPressed: _exportToExcel),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText:
                    'Cari berdasarkan nama pelanggan, dokter, atau barang',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => _filterData(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Mulai',
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    onTap: () => _selectDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Akhir',
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    onTap: () => _selectDate(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PaginatedDataTable(
                header: const Text('Data Resep'),
                rowsPerPage: 10,
                columns: const [
                  DataColumn(label: Text('No Resep')),
                  DataColumn(label: Text('Pelanggan')),
                  DataColumn(label: Text('Doctor')),
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Barang')),
                  DataColumn(label: Text('Kelompok')),
                  DataColumn(label: Text('Satuan')),
                  DataColumn(label: Text('Harga Beli')),
                  DataColumn(label: Text('Harga Jual')),
                ],
                source: dataSource,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResepDataSource extends DataTableSource {
  final List<Resep> data;
  final NumberFormat formatter;

  ResepDataSource(this.data, this.formatter);

  @override
  DataRow getRow(int index) {
    final item = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(item.noResep.toString())),
        DataCell(Text(item.namaPelanggan)),
        DataCell(Text(item.namaDoctor)),
        DataCell(Text(DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(item.tanggal.toString())))),
        DataCell(Text(item.namaBarang)),
        DataCell(Text(item.kelompok)),
        DataCell(Text(item.satuan)),
        DataCell(Text(formatter.format(item.hargaBeli))),
        DataCell(Text(formatter.format(item.hargaJual))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
