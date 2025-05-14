import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pms_flutter/database/app_database.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onMenuTap;
  final AppDatabase database;
  final String? role;

  const Sidebar({
    super.key,
    required this.onMenuTap,
    required this.database,
    required this.role,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isCollapsed = false;
  final FocusNode _logoFocusNode = FocusNode();
  bool _isLaporanExpanded = false;

  String get _role => widget.role ?? '';

  @override
  void initState() {
    super.initState();

    _logoFocusNode.addListener(() {
      if (_logoFocusNode.hasFocus) {
        setState(() {
          _isCollapsed = !_isCollapsed;
          if (_isCollapsed) {
            _isLaporanExpanded = false;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width < 1000;

    return Align(
      alignment: Alignment.centerLeft,
      child: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isCollapsed
              ? 70
              : isTablet
                  ? 250
                  : 190,
          decoration: const BoxDecoration(
            color: Color(0xFFe0f2f1),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppHeader(),
              const Divider(thickness: 1, height: 1),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Tooltip(
                              message: _isCollapsed ? 'Dashboard' : '',
                              child: _menuItem(Icons.dashboard, 'Dashboard')),
                          _divider(),
                          Tooltip(
                              message: _isCollapsed ? 'Supplier' : '',
                              child: _menuItem(Icons.trolley, 'Supplier')),
                          Tooltip(
                              message: _isCollapsed ? 'Dokter' : '',
                              child: _menuItem(Icons.local_hospital, 'Dokter')),
                          Tooltip(
                              message: _isCollapsed ? 'Pelanggan' : '',
                              child: _menuItem(Icons.people_alt, 'Pelanggan')),
                          Tooltip(
                              message: _isCollapsed ? 'Rak' : '',
                              child:
                                  _menuItem(Icons.inventory_outlined, 'Rak')),
                          Tooltip(
                              message: _isCollapsed ? 'Obat' : '',
                              child: _menuItem(Icons.medical_services, 'Obat')),
                          Tooltip(
                              message: _isCollapsed ? 'Pembelian' : '',
                              child:
                                  _menuItem(Icons.shopping_bag, 'Pembelian')),
                          Tooltip(
                              message: _isCollapsed ? 'Penjualan' : '',
                              child:
                                  _menuItem(Icons.point_of_sale, 'Penjualan')),
                          Tooltip(
                              message: _isCollapsed ? 'Resep' : '',
                              child: _menuItem(Icons.receipt_long, 'Resep')),
                          if (_role == 'admin') _divider(),
                          Tooltip(
                            message: _isCollapsed ? 'Laporan' : '',
                            child: _expansionMenuItem(
                              Icons.bar_chart,
                              'Laporan',
                              _isLaporanExpanded,
                              () {
                                setState(() {
                                  _isLaporanExpanded = !_isLaporanExpanded;
                                });
                              },
                              [
                                Tooltip(
                                  message:
                                      _isCollapsed ? 'Laporan Pembelian' : '',
                                  child: _submenuItem(
                                      Icons.show_chart, 'Laporan Pembelian'),
                                ),
                                Tooltip(
                                  message:
                                      _isCollapsed ? 'Laporan Penjualan' : '',
                                  child: _submenuItem(
                                      Icons.show_chart, 'Laporan Penjualan'),
                                ),
                                Tooltip(
                                  message: _isCollapsed ? 'Laporan Resep' : '',
                                  child: _submenuItem(
                                      Icons.assessment, 'Laporan Resep'),
                                ),
                              ],
                            ),
                          ),
                          _divider(),
                          if (_role == 'admin')
                            Tooltip(
                                message: _isCollapsed ? 'User' : '',
                                child: _menuItem(
                                    Icons.supervisor_account, 'User')),
                          Tooltip(
                              message: _isCollapsed ? 'Log Aktivitas' : '',
                              child: _menuItem(Icons.history, 'Log Aktivitas')),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!_isCollapsed)
                            Text(
                              '© 2025 Apotek Segar',
                              style: GoogleFonts.poppins(
                                  fontSize: 11, color: Colors.black54),
                            ),
                          if (!_isCollapsed)
                            Text(
                              'by Kiwari Digital',
                              style: GoogleFonts.poppins(
                                  fontSize: 11, color: Colors.black54),
                            ),
                          if (_isCollapsed)
                            const Icon(Icons.copyright,
                                size: 14, color: Colors.black54),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: GestureDetector(
        onTap: () => setState(() {
          _isCollapsed = !_isCollapsed;
          if (_isCollapsed) {
            _isLaporanExpanded = false;
          }
        }),
        child: Focus(
          focusNode: _logoFocusNode,
          child: Row(
            children: [
              const Icon(Icons.menu, size: 28, color: Colors.black),
              if (!_isCollapsed) ...[
                const SizedBox(width: 5),
                Text(
                  'Apotek Segar',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: _isCollapsed
          ? null
          : Text(
              title,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
      onTap: () {
        widget.onMenuTap(title);
        setState(() {
          _isLaporanExpanded = false;
        });
      },
      dense: true,
      horizontalTitleGap: 12,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _submenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: ListTile(
        leading: Icon(icon, size: 20, color: Colors.black),
        title: !_isCollapsed
            ? Text(
                title,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
              )
            : null,
        onTap: () {
          widget.onMenuTap(title);
          setState(() {
            _isLaporanExpanded = false;
          });
        },
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
              ? Text(
                  title,
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                )
              : null,
          trailing: !_isCollapsed
              ? Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey[700],
                )
              : null,
          onTap: onTap,
        ),
        if (isExpanded) ...children,
      ],
    );
  }

  Widget _divider() => const Divider(thickness: 1, indent: 8, endIndent: 8);
}
