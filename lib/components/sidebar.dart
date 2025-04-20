import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onMenuTap;

  const Sidebar({super.key, required this.onMenuTap});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isCollapsed = false;
  final FocusNode _logoFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _logoFocusNode.addListener(() {
      if (_logoFocusNode.hasFocus) {
        setState(() => _isCollapsed = !_isCollapsed);
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
          duration: const Duration(milliseconds: 250),
          width: _isCollapsed
              ? 70
              : isTablet
                  ? 200
                  : 250,
          decoration: const BoxDecoration(
            color: Color(0xFFe3f2fd),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppHeader(),
              _buildInfoShortcut(),
              const Divider(thickness: 1, height: 1),
              Expanded(
                child: ListView(
                  children: [
                    _menuItem(Icons.dashboard, 'Dashboard'),
                    _divider(),
                    _menuItem(Icons.local_hospital, 'Dokter'),
                    _menuItem(Icons.people_alt, 'Pelanggan'),
                    _menuItem(Icons.shopping_bag, 'Pembelian'),
                    _menuItem(Icons.point_of_sale, 'Penjualan'),
                    _menuItem(Icons.shopping_cart_checkout, 'Pemesanan'),
                    _menuItem(Icons.bar_chart, 'Laporan'),
                    _menuItem(Icons.receipt_long, 'Resep'),
                    _buildBarangExpansion(),
                    _divider(),
                    _menuItem(Icons.person_add_alt_1, 'User'),
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
        onTap: () => setState(() => _isCollapsed = !_isCollapsed),
        child: Focus(
          focusNode: _logoFocusNode,
          child: Row(
            children: [
              const Icon(Icons.menu, size: 28, color: Colors.blue),
              if (!_isCollapsed) ...[
                const SizedBox(width: 8),
                Text(
                  'Pharmacy PMS',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoShortcut() {
    return !_isCollapsed
        ? Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Row(
              children: const [
                Icon(Icons.info_outline, size: 16, color: Colors.blueGrey),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Gunakan tombol TAB untuk toggle sidebar.',
                    style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: _isCollapsed ? null : Text(title),
      onTap: () => widget.onMenuTap(title),
      dense: true,
      horizontalTitleGap: 12,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _divider() => const Divider(thickness: 1, indent: 8, endIndent: 8);

  Widget _buildBarangExpansion() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        visualDensity: VisualDensity.compact,
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.inventory_2),
        title: _isCollapsed ? const SizedBox.shrink() : const Text('Barang'),
        children: [
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: _isCollapsed ? null : const Text('Obat / Jasa'),
            onTap: () => widget.onMenuTap('Obat / Jasa'),
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber),
            title: _isCollapsed ? null : const Text('Obat Expired'),
            onTap: () => widget.onMenuTap('Obat Expired'),
          ),
        ],
      ),
    );
  }
}
