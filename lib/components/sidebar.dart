import 'package:flutter/material.dart';
import 'package:pms_flutter/database/app_database.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onMenuTap;
  final AppDatabase database;
  final String? role;
  const Sidebar(
      {super.key,
      required this.onMenuTap,
      required this.database,
      required this.role});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isCollapsed = false;
  final FocusNode _logoFocusNode = FocusNode();
  bool _isLaporanExpanded = false;
  bool _isBarangExpanded = false;
  String? _role; // <-- Tambahkan ini
  @override
  void initState() {
    super.initState();
    widget.database.getLoggedInUser().then((user) {
      if (mounted) {
        setState(() {
          _role = user?.role;
        });
      }
    });

    _logoFocusNode.addListener(() {
      if (_logoFocusNode.hasFocus) {
        setState(() {
          _isCollapsed = !_isCollapsed;
          if (_isCollapsed) {
            _isLaporanExpanded = false;
            _isBarangExpanded = false;
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
                  : 180,
          decoration: const BoxDecoration(
            color: Color(0xFFe3f2fd),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppHeader(),
              const Divider(thickness: 1, height: 1),
              Expanded(
                child: ListView(
                  children: [
                    Tooltip(
                      message: _isCollapsed ? 'Dashboard' : '',
                      child: _menuItem(Icons.dashboard, 'Dashboard'),
                    ),
                    _divider(),
                    Tooltip(
                      message: _isCollapsed ? 'Supplier' : '',
                      child: _menuItem(Icons.trolley, 'Supplier'),
                    ),
                    Tooltip(
                      message: _isCollapsed ? 'Dokter' : '',
                      child: _menuItem(Icons.local_hospital, 'Dokter'),
                    ),
                    Tooltip(
                      message: _isCollapsed ? 'Pelanggan' : '',
                      child: _menuItem(Icons.people_alt, 'Pelanggan'),
                    ),
                    Tooltip(
                      message: _isCollapsed ? 'Pembelian' : '',
                      child: _menuItem(Icons.shopping_bag, 'Pembelian'),
                    ),
                    Tooltip(
                      message: _isCollapsed ? 'Penjualan' : '',
                      child: _menuItem(Icons.point_of_sale, 'Penjualan'),
                    ),
                    Tooltip(
                      message: _isCollapsed ? 'Resep' : '',
                      child: _menuItem(Icons.receipt_long, 'Resep'),
                    ),
                    Tooltip(
                      message: _isCollapsed ? 'Rak' : '',
                      child: _menuItem(Icons.inventory_outlined, 'Rak'),
                    ),
                    Tooltip(
                      message: _isCollapsed ? 'Laporan' : '',
                      child: _expansionMenuItem(
                        Icons.bar_chart,
                        'Laporan',
                        _isLaporanExpanded,
                        () {
                          setState(() {
                            _isLaporanExpanded = !_isLaporanExpanded;
                            if (_isLaporanExpanded)
                              _isBarangExpanded =
                                  false; // Close 'Barang' if 'Laporan' is expanded
                          });
                        },
                        [
                          Tooltip(
                            message: _isCollapsed ? 'Laporan Pembelian' : '',
                            child: _submenuItem(
                                Icons.show_chart, 'Laporan Pembelian'),
                          ),
                          Tooltip(
                            message: _isCollapsed ? 'Laporan Penjualan' : '',
                            child: _submenuItem(
                                Icons.show_chart, 'Laporan Penjualan'),
                          ),
                          Tooltip(
                            message: _isCollapsed ? 'Laporan Resep' : '',
                            child:
                                _submenuItem(Icons.assessment, 'Laporan Resep'),
                          ),
                          Tooltip(
                            message: _isCollapsed ? 'Laporan User' : '',
                            child: _submenuItem(
                                Icons.my_library_add_rounded, 'Laporan User'),
                          ),
                        ],
                      ),
                    ),
                    Tooltip(
                      message: _isCollapsed ? 'Barang' : '',
                      child: _expansionMenuItem(
                        Icons.inventory,
                        'Barang',
                        _isBarangExpanded,
                        () {
                          setState(() {
                            _isBarangExpanded = !_isBarangExpanded;
                            if (_isBarangExpanded)
                              _isLaporanExpanded =
                                  false; // Close 'Laporan' if 'Barang' is expanded
                          });
                        },
                        [
                          Tooltip(
                            message: _isCollapsed ? 'Obat / Jasa' : '',
                            child: _submenuItem(
                                Icons.medical_services, 'Obat / Jasa'),
                          ),
                          Tooltip(
                            message: _isCollapsed ? 'Obat Expired' : '',
                            child: _submenuItem(Icons.warning, 'Obat Expired'),
                          ),
                        ],
                      ),
                    ),
                    _divider(),
                    if (_role == 'admin')
                      Tooltip(
                        message: _isCollapsed ? 'Tambah User' : '',
                        child: _menuItem(Icons.person_add_alt_1, 'User'),
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
            _isBarangExpanded = false;
          }
        }),
        child: Focus(
          focusNode: _logoFocusNode,
          child: Row(
            children: [
              const Icon(Icons.menu, size: 28, color: Colors.blue),
              if (!_isCollapsed) ...[
                const SizedBox(width: 5),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: _isCollapsed ? null : Text(title),
      onTap: () {
        widget.onMenuTap(title);
        setState(() {
          _isLaporanExpanded = false;
          _isBarangExpanded = false;
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
        leading: Icon(icon, size: 20),
        title: !_isCollapsed
            ? Text(title, style: const TextStyle(fontSize: 14))
            : null,
        onTap: () {
          widget.onMenuTap(title);
          setState(() {
            _isLaporanExpanded = false;
            _isBarangExpanded = false;
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
          leading: Icon(icon),
          title: !_isCollapsed
              ? Text(title)
              : null, // Menampilkan teks jika tidak collapsed
          trailing: !_isCollapsed
              ? Icon(isExpanded ? Icons.expand_less : Icons.expand_more)
              : null, // Menampilkan ikon expand/collapse
          onTap: () {
            setState(() {
              // Toggle expansion saat menu diklik
              isExpanded = !isExpanded;
            });
            onTap(); // Menjalankan onTap untuk update kondisi
          },
        ),
        // Menampilkan submenu jika expanded
        if (isExpanded) ...children,
      ],
    );
  }

  Widget _divider() => const Divider(thickness: 1, indent: 8, endIndent: 8);
}
