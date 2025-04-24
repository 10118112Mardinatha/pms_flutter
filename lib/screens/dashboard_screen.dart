import 'package:flutter/material.dart';
import 'package:pms_flutter/database/app_database.dart';
import '../models/user_model.dart'; // Ganti sesuai path model user kamu
import '../components/sidebar.dart';
import '../components/topbar.dart';
import '../screens/supplier_screen.dart';
import '../screens/barang_screen.dart';
import '../screens/doctor_screen.dart';

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
        return SupplierScreen(database: db);
      case 'Dokter':
        return DoctorScreen(database: db);
      case 'Pelanggan':
        return const Center(child: Text("Halaman Pelanggan"));
      case 'Pembelian':
        return const Center(child: Text("Halaman Pembelian"));
      case 'Penjualan':
        return const Center(child: Text("Halaman Penjualan"));
      case 'Resep':
        return const Center(child: Text("Halaman Resep"));
      case 'Obat / Jasa':
        return BarangScreen(database: db);
      case 'Obat Expired':
        return Center(child: Text('Halaman Obat Expired'));
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
            database: AppDatabase(),
          ),
          Expanded(
            child: Column(
              children: [
                TopBar(user: widget.user),
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
