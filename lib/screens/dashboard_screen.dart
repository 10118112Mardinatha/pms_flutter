import 'package:flutter/material.dart';
import '../models/user_model.dart'; // Ganti sesuai path model user kamu
import '../components/sidebar.dart';
import '../components/topbar.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel user;

  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedPage = 'Dashboard';

  void _onMenuTap(String page) {
    setState(() {
      _selectedPage = page;
    });
  }

  Widget _getPage() {
    switch (_selectedPage) {
      case 'Dokter':
        return const Center(child: Text("Halaman Dokter"));
      case 'Pelanggan':
        return const Center(child: Text("Halaman Pelanggan"));
      case 'Pembelian':
        return const Center(child: Text("Halaman Pembelian"));
      case 'Penjualan':
        return const Center(child: Text("Halaman Penjualan"));
      case 'Resep':
        return const Center(child: Text("Halaman Resep"));
      case 'Barang':
        return const Center(child: Text("Halaman Barang"));
      case 'Obat Expired':
        return const Center(child: Text("Halaman Obat Expired"));
      default:
        return const Center(child: Text("Dashboard Utama"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(onMenuTap: _onMenuTap),
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
