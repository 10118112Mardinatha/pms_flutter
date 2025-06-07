import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:pms_flutter/database/app_database.dart';

import 'package:pms_flutter/models/pembelian_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

class LaporanPembelianScreen extends StatefulWidget {
  final UserModel user;
  const LaporanPembelianScreen({super.key, required this.user});

  @override
  State<LaporanPembelianScreen> createState() => _LaporanPembelianScreenState();
}

class _LaporanPembelianScreenState extends State<LaporanPembelianScreen> {
  List<PembelianModel> allData = [];
  bool isLoading = true;
// Tambahan: debounce untuk pencarian dan filter agar tidak flicker
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
      allData = await ApiService.fetchAllPembelianlap();
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

  List<PembelianModel> get filteredData {
    return allData.where((item) {
      final tanggal = item.tanggalBeli;
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

  List<PembelianModel> get paginatedData {
    final start = currentPage * rowsPerPage;
    return filteredData.skip(start).take(rowsPerPage).toList();
  }

  Future<void> exportToExcel(List<PembelianModel> data) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow([
      'No',
      'No Faktur',
      'Kode Supplier',
      'Nama Supplier',
      'Kode Barang',
      'Nama Barang',
      'Tanggal Beli',
      'Kelompok',
      'Satuan',
      'Harga Beli',
      'Harga Jual',
      'Disc1',
      'Disc2',
      'Disc3',
      'Disc4',
      'Jumlah Beli',
      'Total Harga'
    ]);

    for (int i = 0; i < data.length; i++) {
      final p = data[i];
      sheet.appendRow([
        i + 1,
        p.noFaktur,
        p.kodeSupplier,
        p.namaSuppliers,
        p.kodeBarang,
        p.namaBarang,
        DateFormat('dd-MM-yyyy').format(p.tanggalBeli),
        p.kelompok,
        p.satuan,
        p.hargaBeli,
        p.hargaJual,
        p.jualDisc1 ?? 0,
        p.jualDisc2 ?? 0,
        p.jualDisc3 ?? 0,
        p.jualDisc4 ?? 0,
        p.jumlahBeli ?? 0,
        p.totalHarga ?? 0,
      ]);
    }

    final fileBytes = excel.encode();
    if (fileBytes != null) {
      final fileName =
          'LaporanPembelian_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      await Printing.sharePdf(
          bytes: Uint8List.fromList(fileBytes), filename: fileName);

      // Logging aktivitas export
      final now = DateTime.now();
      final formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);
      await ApiService.logActivity(widget.user.id,
          'Melakukan export data pembelian pada $formattedDate');
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
      appBar: AppBar(title: const Text('📊 Laporan Pembelian')),
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
                                hintText: ' 🔍 Kata kunci...'),
                            onChanged: (value) {
                              setState(() {
                                keyword = value;
                                triggerSearchWithLoading();
                              });
                            },
                          ),
                        ),
                      IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: dateRange != null ? Colors.blue : null,
                        ),
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
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minWidth: constraints.maxWidth,
                                            ),
                                            child: DataTable(
                                              columnSpacing: 24,
                                              columns: const [
                                                DataColumn(label: Text('No')),
                                                DataColumn(
                                                    label: Text('No Faktur')),
                                                DataColumn(
                                                    label:
                                                        Text('Kode Supplier')),
                                                DataColumn(
                                                    label:
                                                        Text('Nama Supplier')),
                                                DataColumn(
                                                    label: Text('Kode Barang')),
                                                DataColumn(
                                                    label: Text('Nama Barang')),
                                                DataColumn(
                                                    label:
                                                        Text('Tanggal Beli')),
                                                DataColumn(
                                                    label: Text('Kelompok')),
                                                DataColumn(
                                                    label: Text('Satuan')),
                                                DataColumn(
                                                    label: Text('Harga Beli')),
                                                DataColumn(
                                                    label: Text('Harga Jual')),
                                                DataColumn(
                                                    label: Text('Disc1')),
                                                DataColumn(
                                                    label: Text('Disc2')),
                                                DataColumn(
                                                    label: Text('Disc3')),
                                                DataColumn(
                                                    label: Text('Disc4')),
                                                DataColumn(
                                                    label: Text('Jumlah Beli')),
                                                DataColumn(
                                                    label: Text('Total Harga')),
                                              ],
                                              rows: List.generate(
                                                paginatedData.length,
                                                (index) {
                                                  final p =
                                                      paginatedData[index];
                                                  return DataRow(cells: [
                                                    DataCell(Text(
                                                        '${currentPage * rowsPerPage + index + 1}')),
                                                    DataCell(Text(p.noFaktur)),
                                                    DataCell(
                                                        Text(p.kodeSupplier)),
                                                    DataCell(
                                                        Text(p.namaSuppliers)),
                                                    DataCell(
                                                        Text(p.kodeBarang)),
                                                    DataCell(
                                                        Text(p.namaBarang)),
                                                    DataCell(Text(DateFormat(
                                                            'dd-MM-yyyy')
                                                        .format(
                                                            p.tanggalBeli))),
                                                    DataCell(Text(p.kelompok)),
                                                    DataCell(Text(p.satuan)),
                                                    DataCell(Text(
                                                        NumberFormat.currency(
                                                                locale: 'id',
                                                                symbol: 'Rp ')
                                                            .format(
                                                                p.hargaBeli))),
                                                    DataCell(Text(
                                                        NumberFormat.currency(
                                                                locale: 'id',
                                                                symbol: 'Rp ')
                                                            .format(
                                                                p.hargaJual))),
                                                    DataCell(Text(
                                                        '${p.jualDisc1 ?? 0}')),
                                                    DataCell(Text(
                                                        '${p.jualDisc2 ?? 0}')),
                                                    DataCell(Text(
                                                        '${p.jualDisc3 ?? 0}')),
                                                    DataCell(Text(
                                                        '${p.jualDisc4 ?? 0}')),
                                                    DataCell(Text(
                                                        '${p.jumlahBeli ?? 0}')),
                                                    DataCell(Text(
                                                        NumberFormat.currency(
                                                                locale: 'id',
                                                                symbol: 'Rp ')
                                                            .format(
                                                                p.totalHarga ??
                                                                    0))),
                                                  ]);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.chevron_left),
                                          onPressed: currentPage > 0
                                              ? () =>
                                                  setState(() => currentPage--)
                                              : null,
                                        ),
                                        Text('Halaman ${currentPage + 1}'),
                                        IconButton(
                                          icon: const Icon(Icons.chevron_right),
                                          onPressed: (currentPage + 1) *
                                                      rowsPerPage <
                                                  filteredData.length
                                              ? () =>
                                                  setState(() => currentPage++)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
