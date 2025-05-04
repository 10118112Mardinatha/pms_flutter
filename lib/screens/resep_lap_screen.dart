import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:pms_flutter/database/app_database.dart';
import 'package:printing/printing.dart';

class LaporanResepScreen extends StatefulWidget {
  final AppDatabase database;

  const LaporanResepScreen({super.key, required this.database});

  @override
  State<LaporanResepScreen> createState() => _LaporanResepScreenState();
}

class _LaporanResepScreenState extends State<LaporanResepScreen> {
  List<Resep> allData = [];
  bool isLoading = true;
  Timer? _debounce;

  void triggerSearchWithLoading() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => isLoading = true);
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() => isLoading = false);
      });
    });
  }

  String selectedFilter = 'Pilih Filter';
  final List<String> filterOptions = [
    'Pilih Filter',
    'No Resep',
    'Nama Barang',
    'Kelompok'
  ];
  String keyword = '';
  DateTimeRange? dateRange;

  int currentPage = 0;
  int rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    final result = await widget.database.select(widget.database.reseps).get();
    setState(() {
      allData = result;
      isLoading = false;
    });
  }

  void clearFilter() {
    setState(() {
      selectedFilter = 'Pilih Filter';
      keyword = '';
      dateRange = null;
      currentPage = 0;
    });
  }

  List<Resep> get filteredData {
    return allData.where((item) {
      final matchDate = dateRange == null ||
          (item.tanggal.isAfter(
                  dateRange!.start.subtract(const Duration(days: 1))) &&
              item.tanggal
                  .isBefore(dateRange!.end.add(const Duration(days: 1))));
      final lowerKeyword = keyword.toLowerCase();
      switch (selectedFilter) {
        case 'No Resep':
          return item.noResep.toLowerCase().contains(lowerKeyword) && matchDate;
        case 'Nama Barang':
          return item.namaBarang.toLowerCase().contains(lowerKeyword) &&
              matchDate;
        case 'Kelompok':
          return item.kelompok.toLowerCase().contains(lowerKeyword) &&
              matchDate;
        default:
          return matchDate;
      }
    }).toList();
  }

  List<Resep> get paginatedData {
    final start = currentPage * rowsPerPage;
    return filteredData.skip(start).take(rowsPerPage).toList();
  }

  Future<void> exportToExcel(List<Resep> data) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow([
      'No',
      'No Resep',
      'Tanggal',
      'Nama Pelanggan',
      'Nama Doctor',
      'Nama Barang',
      'Kelompok',
      'Satuan',
      'Harga Beli',
      'Harga Jual',
      'Jumlah Jual',
      'Total Sebelum Diskon',
      'Total Setelah Diskon',
      'Total Diskon'
    ]);

    for (int i = 0; i < data.length; i++) {
      final r = data[i];
      sheet.appendRow([
        i + 1,
        r.noResep,
        DateFormat('dd-MM-yyyy').format(r.tanggal),
        r.namaPelanggan,
        r.namaDoctor,
        r.namaBarang,
        r.kelompok,
        r.satuan,
        r.hargaBeli,
        r.hargaJual,
        r.jumlahJual ?? 0,
        r.totalHargaSebelumDisc ?? 0,
        r.totalHargaSetelahDisc ?? 0,
        r.totalDisc ?? 0,
      ]);
    }

    final fileBytes = excel.encode();
    if (fileBytes != null) {
      final fileName =
          'LaporanResep_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      await Printing.sharePdf(
          bytes: Uint8List.fromList(fileBytes), filename: fileName);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showTable = selectedFilter != 'Pilih Filter' || dateRange != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Resep')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                DropdownButton<String>(
                  value: selectedFilter,
                  items: filterOptions
                      .map((val) =>
                          DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedFilter = value!),
                ),
                if (selectedFilter != 'Pilih Filter')
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Kata kunci'),
                      onChanged: (value) {
                        setState(() {
                          keyword = value;
                          currentPage = 0;
                          triggerSearchWithLoading();
                        });
                      },
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  tooltip: 'Pilih Tanggal',
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        dateRange = picked;
                        currentPage = 0;
                        triggerSearchWithLoading();
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear Filter',
                  onPressed: () {
                    clearFilter();
                    triggerSearchWithLoading();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  tooltip: 'Export ke Excel',
                  onPressed: () => exportToExcel(filteredData),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : !showTable
                      ? const Center(
                          child: Text('Pilih filter untuk melihat data.'))
                      : filteredData.isEmpty
                          ? const Center(
                              child: Text('Tidak ada data yang cocok.'))
                          : Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('No')),
                                        DataColumn(label: Text('No Resep')),
                                        DataColumn(label: Text('Tanggal')),
                                        DataColumn(label: Text('Pelanggan')),
                                        DataColumn(label: Text('Doctor')),
                                        DataColumn(label: Text('Barang')),
                                        DataColumn(label: Text('Kelompok')),
                                        DataColumn(label: Text('Satuan')),
                                        DataColumn(label: Text('Hrg Beli')),
                                        DataColumn(label: Text('Hrg Jual')),
                                        DataColumn(label: Text('Jumlah')),
                                        DataColumn(
                                            label: Text('Total Sebelum')),
                                        DataColumn(
                                            label: Text('Total Setelah')),
                                        DataColumn(label: Text('Diskon')),
                                      ],
                                      rows: List.generate(paginatedData.length,
                                          (index) {
                                        final r = paginatedData[index];
                                        return DataRow(cells: [
                                          DataCell(Text(
                                              '${index + 1 + currentPage * rowsPerPage}')),
                                          DataCell(Text(r.noResep)),
                                          DataCell(Text(DateFormat('dd-MM-yyyy')
                                              .format(r.tanggal))),
                                          DataCell(Text(r.namaPelanggan)),
                                          DataCell(Text(r.namaDoctor)),
                                          DataCell(Text(r.namaBarang)),
                                          DataCell(Text(r.kelompok)),
                                          DataCell(Text(r.satuan)),
                                          DataCell(Text(
                                              'Rp ${NumberFormat("#,##0", "id_ID").format(r.hargaBeli)}')),
                                          DataCell(Text(
                                              'Rp ${NumberFormat("#,##0", "id_ID").format(r.hargaJual)}')),
                                          DataCell(
                                              Text('${r.jumlahJual ?? 0}')),
                                          DataCell(Text(
                                              'Rp ${NumberFormat("#,##0", "id_ID").format(r.totalHargaSebelumDisc ?? 0)}')),
                                          DataCell(Text(
                                              'Rp ${NumberFormat("#,##0", "id_ID").format(r.totalHargaSetelahDisc ?? 0)}')),
                                          DataCell(Text(
                                              'Rp ${NumberFormat("#,##0", "id_ID").format(r.totalDisc ?? 0)}')),
                                        ]);
                                      }),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: currentPage > 0
                                          ? () => setState(() => currentPage--)
                                          : null,
                                      child: const Text("Prev"),
                                    ),
                                    Text("Halaman ${currentPage + 1}"),
                                    TextButton(
                                      onPressed: (currentPage + 1) *
                                                  rowsPerPage <
                                              filteredData.length
                                          ? () => setState(() => currentPage++)
                                          : null,
                                      child: const Text("Next"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
