import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:pms_flutter/database/app_database.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

class LaporanPembelianScreen extends StatefulWidget {
  final AppDatabase database;

  const LaporanPembelianScreen({super.key, required this.database});

  @override
  State<LaporanPembelianScreen> createState() => _LaporanPembelianScreenState();
}

class _LaporanPembelianScreenState extends State<LaporanPembelianScreen> {
  List<Pembelian> allData = [];
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
    final result =
        await widget.database.select(widget.database.pembelians).get();
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

  List<Pembelian> get filteredData {
    return allData.where((item) {
      final matchDate = dateRange == null ||
          (item.tanggalBeli.isAfter(
                  dateRange!.start.subtract(const Duration(days: 1))) &&
              item.tanggalBeli
                  .isBefore(dateRange!.end.add(const Duration(days: 1))));
      final lowerKeyword = keyword.toLowerCase();
      switch (selectedFilter) {
        case 'No Faktur':
          return item.noFaktur.toLowerCase().contains(lowerKeyword) &&
              matchDate;
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

  List<Pembelian> get paginatedData {
    final start = currentPage * rowsPerPage;
    return filteredData.skip(start).take(rowsPerPage).toList();
  }

  Future<void> exportToExcel(List<Pembelian> data) async {
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
      'Expired',
      'Kelompok',
      'Satuan',
      'Harga Beli',
      'Harga Jual',
      'Disc1',
      'Disc2',
      'Disc3',
      'Disc4',
      'PPN',
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
        DateFormat('dd-MM-yyyy').format(p.expired!),
        p.kelompok,
        p.satuan,
        p.hargaBeli,
        p.hargaJual,
        p.jualDisc1 ?? 0,
        p.jualDisc2 ?? 0,
        p.jualDisc3 ?? 0,
        p.jualDisc4 ?? 0,
        p.ppn ?? 0,
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
      appBar: AppBar(title: const Text('Laporan Pembelian')),
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
                            triggerSearchWithLoading();
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
                            builder: (context, child) => Center(
                                child: SizedBox(width: 400, child: child)),
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
                          : ListView(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('No')),
                                      DataColumn(label: Text('No Faktur')),
                                      DataColumn(label: Text('Kode Supplier')),
                                      DataColumn(label: Text('Nama Supplier')),
                                      DataColumn(label: Text('Kode Barang')),
                                      DataColumn(label: Text('Nama Barang')),
                                      DataColumn(label: Text('Tanggal Beli')),
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
                                      DataColumn(label: Text('Jumlah Beli')),
                                      DataColumn(label: Text('Total Harga')),
                                    ],
                                    rows: List.generate(
                                      paginatedData.length,
                                      (index) {
                                        final p = paginatedData[index];
                                        return DataRow(cells: [
                                          DataCell(Text(
                                              '${currentPage * rowsPerPage + index + 1}')),
                                          DataCell(Text(p.noFaktur)),
                                          DataCell(Text(p.kodeSupplier)),
                                          DataCell(Text(p.namaSuppliers)),
                                          DataCell(Text(p.kodeBarang)),
                                          DataCell(Text(p.namaBarang)),
                                          DataCell(Text(DateFormat('dd-MM-yyyy')
                                              .format(p.tanggalBeli))),
                                          DataCell(Text(
                                            p.expired == null
                                                ? ''
                                                : DateFormat('dd-MM-yyyy')
                                                    .format(p.expired!),
                                          )),
                                          DataCell(Text(p.kelompok)),
                                          DataCell(Text(p.satuan)),
                                          DataCell(Text(NumberFormat.currency(
                                                  locale: 'id', symbol: 'Rp ')
                                              .format(p.hargaBeli))),
                                          DataCell(Text(NumberFormat.currency(
                                                  locale: 'id', symbol: 'Rp ')
                                              .format(p.hargaJual))),
                                          DataCell(Text('${p.jualDisc1 ?? 0}')),
                                          DataCell(Text('${p.jualDisc2 ?? 0}')),
                                          DataCell(Text('${p.jualDisc3 ?? 0}')),
                                          DataCell(Text('${p.jualDisc4 ?? 0}')),
                                          DataCell(Text('${p.ppn ?? 0}')),
                                          DataCell(
                                              Text('${p.jumlahBeli ?? 0}')),
                                          DataCell(Text(NumberFormat.currency(
                                                  locale: 'id', symbol: 'Rp ')
                                              .format(p.totalHarga ?? 0))),
                                        ]);
                                      },
                                    ),
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
