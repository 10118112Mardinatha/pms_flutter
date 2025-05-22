import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:pms_flutter/database/app_database.dart';
import 'package:pms_flutter/models/log_activity_model.dart';
import 'package:pms_flutter/models/penjualan_model.dart';
import 'package:pms_flutter/screens/kasir_penjualan_screen.dart';
import 'package:pms_flutter/screens/pelanggan_screen.dart';
import 'package:pms_flutter/screens/pembelian_lap_screen.dart';
import 'package:pms_flutter/screens/pembelian_screen.dart';
import 'package:pms_flutter/screens/penjualan_lap_screen.dart';
import 'package:pms_flutter/screens/penjualan_screen.dart';
import 'package:pms_flutter/screens/riwayat_user_screen.dart';
import 'package:pms_flutter/screens/resep_lap_screen.dart';
import 'package:pms_flutter/screens/resep_screen.dart';
import 'package:pms_flutter/services/api_service.dart';
import '../models/user_model.dart'; // Ganti sesuai path model user kamu
import '../components/sidebar.dart';
import '../components/topbar.dart';
import '../screens/supplier_screen.dart';
import '../screens/barang_screen.dart';
import '../screens/doctor_screen.dart';
import '../screens/rak_screen.dart';
import '../screens/user_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel user;

  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedPage = 'Dashboard';
  final AppDatabase db = AppDatabase();
  int? totalpembelian;
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  List<PenjualanModel> menunggu = [];
  String searchQuery = '';
  bool isLoading = true;

  void _onMenuTap(String page) {
    setState(() {
      _selectedPage = page;
    });
  }

  Future<int> updateTotalPembelian() async {
    final total = await ApiService.getTotalPembeliantoDay();
    return total;
  }

  Future<int> updateTotalPenjualan() async {
    final total = await ApiService.getTotalPenjualantoDay();
    return total;
  }

  Future<void> fetchMenungguData() async {
    try {
      final all = await ApiService.fetchAllPenjualanlap();
      menunggu = all.where((p) => p.status == 'menunggu').toList();
    } catch (e) {
      debugPrint('Gagal memuat data penjualan: $e');
    }
  }

  Map<String, List<PenjualanModel>> get groupedByFaktur {
    final map = <String, List<PenjualanModel>>{};

    for (final item in menunggu) {
      final nama = item.namaPelanggan?.toLowerCase() ?? '';
      if (searchQuery.trim().isEmpty || nama.contains(searchQuery)) {
        map.putIfAbsent(item.noFaktur, () => []).add(item);
      }
    }

    return map;
  }

  Widget _getPage() {
    switch (_selectedPage) {
      case 'Supplier':
        return SupplierScreen(user: widget.user);
      case 'Dokter':
        return DoctorScreen(user: widget.user);
      case 'Pelanggan':
        return PelangganScreen(user: widget.user);
      case 'Pembelian':
        return PembelianScreen(user: widget.user);
      case 'Penjualan':
        return PenjualanScreen(user: widget.user);
      case 'Kasir':
        return KasirPenjualanScreen(user: widget.user);
      case 'Resep':
        return ResepScreen(user: widget.user);
      case 'Rak':
        return RakScreen(user: widget.user);
      case 'Laporan Pembelian':
        return LaporanPembelianScreen();
      case 'Laporan Penjualan':
        return LaporanPenjualanScreen(database: db);
      case 'Laporan Resep':
        return LaporanResepScreen(database: db);
      case 'Obat':
        return BarangScreen(user: widget.user);
      case 'User':
        return TambahUserScreen(currentUserId: widget.user.id);
      case 'Log Aktivitas':
        return const RiwayatUserScreen();
      default:
        return _buildDashboardContent();
    }
  }

  Future<int> _getJumlahPelanggan() async {
    try {
      final response = await ApiService.fetchAllPelanggan();
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.length;
      } else {
        throw Exception('Gagal mengambil data dokter');
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  static Future<int> _getJumlahDoctor() async {
    try {
      final response = await ApiService.fetchAllDokter();
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.length;
      } else {
        throw Exception('Gagal mengambil data dokter');
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  static Future<int> _getJumlahBarang() async {
    try {
      final response = await ApiService.fetchAllBarang();
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.length;
      } else {
        throw Exception('Gagal mengambil data dokter');
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Widget _buildDashboardContent() {
    fetchMenungguData();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kiri: Card 2x2
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCardWelcomeAsync(
                        Icons.hail,
                        'Selamat Datang di Dashboard,',
                        '${widget.user.username}!'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCardAsync(
                        Icons.people_alt,
                        'Jumlah Pelanggan',
                        _getJumlahPelanggan().then((val) => val.toString())),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDashboardCardAsync(
                        Icons.local_hospital,
                        'Jumlah Dokter',
                        _getJumlahDoctor().then((val) => val.toString())),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDashboardCardAsync(
                        Icons.inventory_2,
                        'Jumlah Barang',
                        _getJumlahBarang().then((val) => val.toString())),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCardAsync(
                        Icons.point_of_sale,
                        'Total Penjualan hari ini',
                        updateTotalPenjualan()
                            .then((val) => formatter.format(val))),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCardAsync(
                        Icons.shopping_bag,
                        'Total Pembelian hari ini',
                        updateTotalPembelian()
                            .then((val) => formatter.format(val))),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 32),

        // Kanan: Recent Files
        Expanded(
          flex: 2,
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Penjualan Menunggu pembayaran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  // Agar tabel mengisi ruang vertikal sepenuhnya

                  _buildRecentFilesTable(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDashboardCardAsync(
      IconData icon, String title, Future<String> futureValue) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue.shade700),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: futureValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return Text(
                    snapshot.data!,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCardWelcomeAsync(
      IconData icon, String title, String nama) {
    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 8),
            Text(
              nama,
              style: const TextStyle(fontSize: 25, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentFilesTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Sudut membulat
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(12), // Untuk konten di dalam Card
            child: DataTable(
              columns: const [
                DataColumn(label: Center(child: Text('No Faktur'))),
                DataColumn(label: Center(child: Text('No Resep'))),
                DataColumn(label: Center(child: Text('Pelanggan'))),
                DataColumn(label: Center(child: Text('Total bayar'))),
              ],
              rows: groupedByFaktur.entries.map((entry) {
                final faktur = entry.key;
                final items = entry.value;
                final noresep = items.first.noResep;
                final pelanggan = items.first.namaPelanggan;
                final totalBayar = items.fold<int>(
                    0, (sum, i) => sum + (i.totalHargaSetelahDisc ?? 0));

                return DataRow(cells: [
                  DataCell(Text(faktur)),
                  DataCell(Text(noresep ?? '-')),
                  DataCell(SizedBox(
                      width: 100,
                      child: Text(
                        pelanggan ?? '-',
                        overflow: TextOverflow.ellipsis,
                      ))),
                  DataCell(Text(totalBayar.toString() ?? '-')),
                ]);
              }).toList(),
              columnSpacing: 5,
              headingRowColor: MaterialStateProperty.all(Colors.blue),
              headingRowHeight: 50,
              dataRowHeight: 43,
              dataRowColor: MaterialStateProperty.all(Colors.white),
              headingTextStyle: TextStyle(color: Colors.white),
              dividerThickness: 0.5,
              dataTextStyle: TextStyle(fontSize: 11),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            onMenuTap: _onMenuTap,
            role: widget.user.role,
            akses: widget.user.akses,
          ),
          Expanded(
            child: Column(
              children: [
                TopBar(
                  user: widget.user,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _getPage(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
