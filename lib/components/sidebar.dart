// Ganti seluruh isi Sidebar.dart kamu dengan ini
// Pastikan import dan font tetap

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onMenuTap;
  final String? role;

  const Sidebar({
    super.key,
    required this.onMenuTap,
    required this.role,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isCollapsed = false;
  bool _isLaporanExpanded = false;

  final FocusNode _logoFocusNode = FocusNode();

  String get _role => widget.role ?? '';

  @override
  void initState() {
    super.initState();
    _logoFocusNode.addListener(() {
      if (_logoFocusNode.hasFocus) {
        _toggleSidebar();
      }
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
      if (_isCollapsed) _isLaporanExpanded = false;
    });
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
          decoration: const BoxDecoration(
            color: Color(0xFFe0f2f1),
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
                        color: Colors.blue[900],
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
    return ListView(
      children: [
        if (_isAdmin || _isKasir || _isCounter) ...[
          _tooltipItem('Dashboard', Icons.dashboard),
        ],
        if (_isAdmin || _isKasir || _isCounter) _divider(),
        if (_isAdmin) _tooltipItem('Supplier', Icons.trolley),
        if (_isAdmin) _tooltipItem('Dokter', Icons.medical_services_outlined),
        if (_isAdmin) _tooltipItem('Pelanggan', Icons.people_alt),
        if (_isAdmin) _tooltipItem('Rak', Icons.inventory_outlined),
        if (_isAdmin) _tooltipItem('Obat', Icons.medical_services),
        if (_isAdmin) _tooltipItem('Pembelian', Icons.shopping_cart),

        // Akses Penjualan & Kasir
        if (_isAdmin || _isKasir || _isCounter)
          _tooltipItem('Penjualan', Icons.point_of_sale),
        if (_isAdmin || _isKasir) _tooltipItem('Kasir', Icons.payment),

        // Resep hanya untuk admin
        if (_isAdmin) _tooltipItem('Resep', Icons.receipt_long),

        if (_isAdmin) _divider(),

        // Laporan untuk admin
        if (_isAdmin)
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
              _submenuItem('Laporan Pembelian', Icons.show_chart),
              _submenuItem('Laporan Penjualan', Icons.show_chart),
              _submenuItem('Laporan Resep', Icons.assessment),
            ],
          ),

        if (_isAdmin) _divider(),

        if (_isAdmin) _tooltipItem('User', Icons.supervisor_account),
        if (_isAdmin) _tooltipItem('Log Aktivitas', Icons.history),
      ],
    );
  }

  Widget _tooltipItem(String title, IconData icon) {
    return Tooltip(
      message: _isCollapsed ? title : '',
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: !_isCollapsed
            ? Text(title,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87))
            : null,
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
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: ListTile(
        leading: Icon(icon, size: 20, color: Colors.black),
        title: !_isCollapsed
            ? Text(title,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87))
            : null,
        onTap: () {
          widget.onMenuTap(title);
          setState(() => _isLaporanExpanded = false);
        },
        dense: true,
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
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black87))
              : null,
          trailing: !_isCollapsed
              ? Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey[700],
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
                style:
                    GoogleFonts.poppins(fontSize: 11, color: Colors.black54)),
          if (!_isCollapsed)
            Text('by Kiwari Digital',
                style:
                    GoogleFonts.poppins(fontSize: 11, color: Colors.black54)),
          if (_isCollapsed)
            const Icon(Icons.copyright, size: 14, color: Colors.black54),
        ],
      ),
    );
  }
}
