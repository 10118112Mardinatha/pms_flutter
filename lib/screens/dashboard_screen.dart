import 'package:flutter/material.dart';
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

  Widget _buildDashboardContent() {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildDashboardCard(Icons.people_alt, 'Jumlah Pelanggan', '123'),
        _buildDashboardCard(Icons.local_hospital, 'Jumlah Dokter', '15'),
        _buildDashboardCard(Icons.inventory_2, 'Jumlah Barang', '58'),
        _buildDashboardCard(
            Icons.shopping_bag, 'Total Pembelian', 'Rp 1.250.000'),
        _buildDashboardCard(
            Icons.point_of_sale, 'Total Penjualan', 'Rp 2.100.000'),
        _buildDashboardCard(Icons.receipt_long, 'Total Resep', '87'),
        _buildDashboardCard(Icons.medication_liquid, 'Obat Expired', '4'),
        _buildDashboardCard(Icons.pending_actions, 'Pemesanan Aktif', '12'),
      ],
    );
  }

  Widget _buildDashboardCard(IconData icon, String title, String value) {
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
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            onMenuTap: _onMenuTap,
            role: widget.user.role,
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
