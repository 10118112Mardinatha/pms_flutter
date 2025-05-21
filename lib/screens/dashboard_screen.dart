import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pms_flutter/database/app_database.dart';
import 'package:pms_flutter/models/log_activity_model.dart';
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

  void _onMenuTap(String page) {
    setState(() {
      _selectedPage = page;
    });
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kiri: Card 2x2
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(children: [
                Text(
                  'DASHBOARD',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(height: 10),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCardAsync(
                        Icons.point_of_sale,
                        'Total Penjualan hari ini',
                        _getJumlahPelanggan().then((val) => val.toString())),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDashboardCardAsync(
                        Icons.shopping_bag,
                        'Total Pembelian hari ini',
                        _getJumlahPelanggan().then((val) => val.toString())),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 32),

        // Kanan: Recent Files
        Expanded(
          flex: 1,
          child: Card(
            elevation: 3,
            color: Color(0xFFe3f2fd),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Barang keluar terbaru',
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

  Widget _buildRecentFilesTable() {
    final recentFiles = [
      {'name': 'Document', 'date': '2', 'size': '32'},
      {'name': 'Docume', 'date': '2', 'size': '32'},
      {'name': 'Document', 'date': '2', 'size': '32'},
      {'name': 'Document', 'date': '2', 'size': '32'},
      {'name': 'Document', 'date': '2', 'size': '32'},
      {'name': 'Document', 'date': '2', 'size': '32'},
      {'name': 'Document', 'date': '2', 'size': '32'},
      {'name': 'Document', 'date': '2', 'size': '32'},
      {'name': 'Document', 'date': '2', 'size': '32'},
      {'name': 'Document', 'date': '2', 'size': '32'},
      {'name': 'Document', 'date': '2', 'size': '32'},
    ];

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
                DataColumn(label: Text('Nama barang')),
                DataColumn(label: Text('Jumlah')),
                DataColumn(label: Text('Total Bayar')),
              ],
              rows: recentFiles
                  .map(
                    (file) => DataRow(
                      cells: [
                        DataCell(Text(file['name']!)),
                        DataCell(Text(file['date']!)),
                        DataCell(Text(file['size']!)),
                      ],
                    ),
                  )
                  .toList(),
              columnSpacing: 5,
              headingRowColor: MaterialStateProperty.all(Colors.blue),
              headingRowHeight: 50,
              dataRowHeight: 43,
              dataRowColor: MaterialStateProperty.all(Colors.white),
              headingTextStyle: TextStyle(color: Colors.white),
              dividerThickness: 0.5,
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
