import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:pms_flutter/database/app_database.dart';
import 'package:pms_flutter/models/penjualan_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

class LaporanPenjualanScreen extends StatefulWidget {
  final AppDatabase database;

  const LaporanPenjualanScreen({super.key, required this.database});

  @override
  State<LaporanPenjualanScreen> createState() => _LaporanPenjualanScreenState();
}

class _LaporanPenjualanScreenState extends State<LaporanPenjualanScreen> {
  List<PenjualanModel> allData = [];
  bool isLoading = true;
  Timer? _debounce;
  void triggerSearchWithLoading() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
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
    'No Faktur',
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
    try {
      allData = await ApiService.fetchAllPenjualanlap();
    } catch (e) {
      debugPrint('Gagal fetch dari API: $e');
    }
    setState(() => isLoading = false);
  }

  void clearFilter() {
    setState(() {
      selectedFilter = 'Pilih Filter';
      keyword = '';
      dateRange = null;
      currentPage = 0;
    });
  }

  List<PenjualanModel> get filteredData {
    return allData.where((item) {
      final tanggal = item.tanggalPenjualan;
      final matchDate = tanggal != null &&
          (dateRange == null ||
              (tanggal.isAfter(
                      dateRange!.start.subtract(const Duration(days: 1))) &&
                  tanggal
                      .isBefore(dateRange!.end.add(const Duration(days: 1)))));

      final lowerKeyword = keyword.toLowerCase();

      switch (selectedFilter) {
        case 'No Faktur':
          return (item.noFaktur?.toLowerCase().contains(lowerKeyword) ??
                  false) &&
              matchDate;
        case 'Nama Barang':
          return (item.namaBarang?.toLowerCase().contains(lowerKeyword) ??
                  false) &&
              matchDate;
        case 'Kelompok':
          return (item.kelompok?.toLowerCase().contains(lowerKeyword) ??
                  false) &&
              matchDate;
        default:
          return matchDate;
      }
    }).toList();
  }

  List<PenjualanModel> get paginatedData {
    final start = currentPage * rowsPerPage;
    return filteredData.skip(start).take(rowsPerPage).toList();
  }

  Future<void> exportToExcel(List<PenjualanModel> data) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow([
      'No',
      'No Faktur',
      'Nama Barang',
      'Nama Pelanggan',
      'Nama Dokter',
      'Tanggal Beli',
      'Kelompok',
      'Harga Beli',
      'Harga Jual',
      'Total Setelah Diskon'
    ]);

    for (int i = 0; i < data.length; i++) {
      final p = data[i];
      sheet.appendRow([
        i + 1,
        p.noFaktur,
        p.namaBarang,
        p.namaPelanggan,
        p.namaDoctor,
        DateFormat('dd-MM-yyyy').format(p.tanggalPenjualan),
        p.kelompok,
        p.hargaBeli,
        p.hargaJual,
        p.totalHargaSetelahDisc ?? 0,
      ]);
    }

    final fileBytes = excel.encode();
    if (fileBytes != null) {
      final fileName =
          'LaporanPenjualan_${DateTime.now().millisecondsSinceEpoch}.xlsx';
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
    final showTable = keyword.trim().isNotEmpty || dateRange != null;

    return Scaffold(
      appBar: AppBar(title: const Text('📊 Laporan Penjualan')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: selectedFilter,
                        items: filterOptions
                            .map((filter) => DropdownMenuItem(
                                  value: filter,
                                  child: Text(filter),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFilter = value!;
                            keyword = '';
                          });
                        },
                      ),
                      if (selectedFilter != 'Pilih Filter')
                        SizedBox(
                          width: 200,
                          child: TextField(
                            decoration: const InputDecoration(
                                hintText: 'Kata kunci...'),
                            onChanged: (value) {
                              setState(() {
                                keyword = value;
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
                            builder: (context, child) {
                              return Center(
                                child: SizedBox(
                                  width: 360,
                                  height: 460,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dialogTheme: DialogTheme(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      colorScheme: Theme.of(context)
                                          .colorScheme
                                          .copyWith(
                                            primary: Colors.blue,
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                    ),
                                    child: MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 0.9),
                                      child: child!,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              dateRange = picked;
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
                        tooltip: 'Export Excel',
                        onPressed: () => exportToExcel(filteredData),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: rowsPerPage,
                  onChanged: (value) {
                    setState(() {
                      rowsPerPage = value!;
                      currentPage = 0;
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('10 Baris')),
                    DropdownMenuItem(value: 20, child: Text('20 Baris')),
                    DropdownMenuItem(value: 30, child: Text('30 Baris')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : !showTable
                      ? const Center(
                          child: Text(
                              'Silakan pilih filter terlebih dahulu untuk menampilkan data.'))
                      : filteredData.isEmpty
                          ? const Center(
                              child: Text('Tidak ada data yang cocok'))
                          : Column(
                              children: [
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minWidth: constraints.maxWidth),
                                          child: DataTable(
                                            columnSpacing: 24,
                                            columns: const [
                                              DataColumn(label: Text('No')),
                                              DataColumn(
                                                  label: Text('No Faktur')),
                                              DataColumn(
                                                  label: Text('Nama Barang')),
                                              DataColumn(
                                                  label:
                                                      Text('Nama Pelanggan')),
                                              DataColumn(
                                                  label: Text('Nama Dokter')),
                                              DataColumn(
                                                  label: Text('Tanggal Beli')),
                                              DataColumn(
                                                  label: Text('Kelompok')),
                                              DataColumn(
                                                  label: Text('Harga Beli')),
                                              DataColumn(
                                                  label: Text('Harga Jual')),
                                              DataColumn(
                                                  label: Text('Total Harga')),
                                              DataColumn(label: Text('Status')),
                                            ],
                                            rows: List.generate(
                                              paginatedData.length,
                                              (index) {
                                                final p = paginatedData[index];
                                                return DataRow(cells: [
                                                  DataCell(Text(
                                                      '${currentPage * rowsPerPage + index + 1}')),
                                                  DataCell(Text(p.noFaktur)),
                                                  DataCell(Text(p.namaBarang)),
                                                  DataCell(
                                                      Text(p.namaPelanggan)),
                                                  DataCell(Text(p.namaDoctor)),
                                                  DataCell(Text(DateFormat(
                                                          'dd-MM-yyyy')
                                                      .format(
                                                          p.tanggalPenjualan))),
                                                  DataCell(Text(p.kelompok)),
                                                  DataCell(Text(
                                                      'Rp ${NumberFormat("#,##0", "id_ID").format(p.hargaBeli)}')),
                                                  DataCell(Text(
                                                      'Rp ${NumberFormat("#,##0", "id_ID").format(p.hargaJual)}')),
                                                  DataCell(Text(
                                                      'Rp ${NumberFormat("#,##0", "id_ID").format(p.totalHargaSetelahDisc ?? 0)}')),
                                                  DataCell(Text(p.status)),
                                                ]);
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.chevron_left),
                                      onPressed: currentPage > 0
                                          ? () => setState(() => currentPage--)
                                          : null,
                                    ),
                                    Text('Halaman ${currentPage + 1}'),
                                    IconButton(
                                      icon: const Icon(Icons.chevron_right),
                                      onPressed: (currentPage + 1) *
                                                  rowsPerPage <
                                              filteredData.length
                                          ? () => setState(() => currentPage++)
                                          : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
            )
          ],
        ),
      ),
    );
  }
}
