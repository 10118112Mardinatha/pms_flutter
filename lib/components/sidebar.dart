// Ganti seluruh isi Sidebar.dart kamu dengan ini
// Pastikan import dan font tetap

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final FocusNode _logoFocusNode = FocusNode();

  String get _role => widget.role ?? '';
  bool hasAccess(String menuKey) => widget.akses.contains(menuKey);

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
    ].any((key) => hasAccess(key));

    final hasLaporanAccess = widget.akses.any((a) => a.startsWith('laporan_'));

    final hasUserAccess = hasAccess('user') || hasAccess('log_aktivitas');

    return ListView(
      children: [
        if (hasAccess('dashboard'))
          _tooltipItem(capitalizeLabel('dashboard'), Icons.dashboard),
        if (hasMasterAccess) _divider(),
        if (hasAccess('supplier'))
          _tooltipItem(capitalizeLabel('supplier'), Icons.trolley),
        if (hasAccess('dokter'))
          _tooltipItem(
              capitalizeLabel('dokter'), Icons.medical_services_outlined),
        if (hasAccess('pelanggan'))
          _tooltipItem(capitalizeLabel('pelanggan'), Icons.people_alt),
        if (hasAccess('rak'))
          _tooltipItem(capitalizeLabel('rak'), Icons.inventory_outlined),
        if (hasAccess('obat'))
          _tooltipItem(capitalizeLabel('obat'), Icons.medical_services),
        if (hasAccess('pembelian'))
          _tooltipItem(capitalizeLabel('pembelian'), Icons.shopping_cart),
        if (hasAccess('penjualan'))
          _tooltipItem(capitalizeLabel('penjualan'), Icons.point_of_sale),
        if (hasAccess('kasir'))
          _tooltipItem(capitalizeLabel('kasir'), Icons.payment),
        if (hasAccess('resep'))
          _tooltipItem(capitalizeLabel('resep'), Icons.receipt_long),
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
          _tooltipItem(capitalizeLabel('user'), Icons.supervisor_account),
        if (hasAccess('log_aktivitas'))
          _tooltipItem(capitalizeLabel('log_aktivitas'), Icons.history),
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
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white))
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
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.white))
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
