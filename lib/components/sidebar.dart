// Ganti seluruh isi Sidebar.dart kamu dengan ini
// Pastikan import dan font tetap

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pms_flutter/services/api_service.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onMenuTap;
  final String? role;
  final List<String> akses;

  const Sidebar({
    super.key,
    required this.onMenuTap,
    required this.role,
    required this.akses,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isCollapsed = false;
  bool _isLaporanExpanded = false;
  Timer? _timer;
  final FocusNode _logoFocusNode = FocusNode();

  String get _role => widget.role ?? '';
  bool hasAccess(String menuKey) => widget.akses.contains(menuKey);
  int _jumlahMenunggu = 0;
  bool _isLoadingMenunggu = true;

  @override
  void initState() {
    super.initState();
    fetchMenungguData();
    _timer = Timer.periodic(Duration(seconds: 10), (_) => fetchMenungguData());
    _logoFocusNode.addListener(() {
      if (_logoFocusNode.hasFocus) {
        _toggleSidebar();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logoFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchMenungguData() async {
    try {
      final all = await ApiService.fetchAllPenjualanlap();
      final menunggu = all.where((p) => p.status == 'menunggu').toList();
      setState(() {
        _jumlahMenunggu = menunggu.length;
        _isLoadingMenunggu = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat data menunggu: $e');
      setState(() => _isLoadingMenunggu = false);
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
      if (_isCollapsed) _isLaporanExpanded = false;
    });

    // Panggil fetch untuk refresh data
    fetchMenungguData();
  }

  bool get _isAdmin => _role == 'admin';
  bool get _isKasir => _role == 'kasir';
  bool get _isCounter => _role == 'counter';

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width < 1000;

    return Align(
      alignment: Alignment.centerLeft,
      child: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: _isCollapsed ? 70 : (isTablet ? 240 : 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.teal.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const Divider(thickness: 1),
              Expanded(child: _buildMenuItems()),
              const Divider(thickness: 1),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: _toggleSidebar,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Focus(
          focusNode: _logoFocusNode,
          child: Row(
            children: [
              const Icon(Icons.menu, size: 26, color: Colors.black),
              if (!_isCollapsed)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Apotek Segar',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    String capitalizeLabel(String key) {
      return key
          .split('_')
          .map((w) => w[0].toUpperCase() + w.substring(1))
          .join(' ');
    }

    bool hasAccess(String key) => widget.akses.contains(key);

    final hasMasterAccess = [
      'supplier',
      'dokter',
      'pelanggan',
      'rak',
      'obat',
      'pembelian',
      'penjualan',
      'kasir',
      'resep',
      'pesanan',
    ].any((key) => hasAccess(key));

    final hasLaporanAccess = widget.akses.any((a) => a.startsWith('laporan_'));

    final hasUserAccess = hasAccess('user') || hasAccess('log_aktivitas');

    return ListView(
      children: [
        if (hasAccess('dashboard'))
          _tooltipItem(capitalizeLabel('dashboard'),
              const Icon(Icons.dashboard, color: Colors.black)),
        if (hasMasterAccess) _divider(),
        if (hasAccess('supplier'))
          _tooltipItem(capitalizeLabel('supplier'),
              Icon(Icons.trolley, color: Colors.black)),
        if (hasAccess('dokter'))
          _tooltipItem(capitalizeLabel('dokter'),
              Icon(Icons.medical_services_outlined, color: Colors.black)),
        if (hasAccess('pelanggan'))
          _tooltipItem(capitalizeLabel('pelanggan'),
              Icon(Icons.people_alt, color: Colors.black)),
        if (hasAccess('rak'))
          _tooltipItem(capitalizeLabel('rak'),
              Icon(Icons.inventory_outlined, color: Colors.black)),
        if (hasAccess('obat'))
          _tooltipItem(capitalizeLabel('obat'),
              Icon(Icons.medical_services, color: Colors.black)),
        if (hasAccess('pembelian'))
          _tooltipItem(capitalizeLabel('pembelian'),
              Icon(Icons.shopping_cart, color: Colors.black)),
        if (hasAccess('penjualan'))
          _tooltipItem(capitalizeLabel('penjualan'),
              Icon(Icons.point_of_sale, color: Colors.black)),
        if (hasAccess('kasir'))
          _tooltipItem(
            capitalizeLabel('kasir'),
            Icon(Icons.payment, color: Colors.black),
            trailing: (!_isLoadingMenunggu && _jumlahMenunggu > 0)
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_jumlahMenunggu',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
        if (hasAccess('resep'))
          _tooltipItem(capitalizeLabel('resep'),
              Icon(Icons.receipt_long, color: Colors.black)),
        if (hasAccess('pesanan'))
          _tooltipItem(capitalizeLabel('pesanan'),
              Icon(Icons.shopping_bag, color: Colors.black)),
        if (hasLaporanAccess) _divider(),
        if (hasLaporanAccess)
          _expansionMenuItem(
            Icons.bar_chart,
            'Laporan',
            _isLaporanExpanded,
            () {
              setState(() {
                _isLaporanExpanded = !_isLaporanExpanded;
              });
            },
            [
              if (hasAccess('laporan_pembelian'))
                _submenuItem(
                    capitalizeLabel('laporan_pembelian'), Icons.show_chart),
              if (hasAccess('laporan_penjualan'))
                _submenuItem(
                    capitalizeLabel('laporan_penjualan'), Icons.show_chart),
              if (hasAccess('laporan_resep'))
                _submenuItem(
                    capitalizeLabel('laporan_resep'), Icons.assessment),
            ],
          ),
        if (hasUserAccess) _divider(),
        if (hasAccess('user'))
          _tooltipItem(capitalizeLabel('user'),
              Icon(Icons.supervisor_account, color: Colors.black)),
        if (hasAccess('log_aktivitas'))
          _tooltipItem(capitalizeLabel('log_aktivitas'),
              Icon(Icons.history, color: Colors.black)),
      ],
    );
  }

  Widget _tooltipItem(String title, Widget leading, {Widget? trailing}) {
    return Tooltip(
      message: _isCollapsed ? title : '',
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            leading,
            // Tampilkan badge juga saat collapse (kondisi ada trailing dan collapse)
            if (_isCollapsed && trailing != null)
              Positioned(
                right: -6,
                top: -6,
                child: trailing,
              ),
          ],
        ),
        title: !_isCollapsed
            ? Text(title,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white))
            : null,
        trailing: !_isCollapsed ? trailing : null,
        onTap: () {
          widget.onMenuTap(title);
          setState(() => _isLaporanExpanded = false);
        },
        dense: true,
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 12,
      ),
    );
  }

  Widget _submenuItem(String title, IconData icon) {
    return Tooltip(
      message: _isCollapsed ? title : '',
      child: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: ListTile(
          leading: Icon(icon, size: 20, color: Colors.black),
          title: !_isCollapsed
              ? Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
                )
              : null,
          onTap: () {
            widget.onMenuTap(title);
            setState(() => _isLaporanExpanded = false);
          },
          dense: true,
          visualDensity: VisualDensity.compact,
          horizontalTitleGap: 12,
        ),
      ),
    );
  }

  Widget _expansionMenuItem(
    IconData icon,
    String title,
    bool isExpanded,
    VoidCallback onTap,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: !_isCollapsed
              ? Text(title,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white))
              : null,
          trailing: !_isCollapsed
              ? Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                )
              : null,
          onTap: onTap,
          dense: true,
        ),
        if (isExpanded) ...children,
      ],
    );
  }

  Widget _divider() => const Divider(thickness: 1, indent: 8, endIndent: 8);

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isCollapsed)
            Text('© 2025 Apotek Segar',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white)),
          if (!_isCollapsed)
            Text('by Kiwari Digital',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white)),
          if (_isCollapsed)
            const Icon(Icons.copyright, size: 14, color: Colors.black54),
        ],
      ),
    );
  }
}
