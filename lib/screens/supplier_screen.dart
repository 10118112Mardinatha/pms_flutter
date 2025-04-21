import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../database/app_database.dart';

class SupplierScreen extends StatefulWidget {
  final AppDatabase database;

  const SupplierScreen({super.key, required this.database});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  late AppDatabase db;

  @override
  void initState() {
    super.initState();
    db = widget.database;
  }

  void _showForm({Supplier? supplier}) {
    final kodeCtrl = TextEditingController(text: supplier?.kodeSupplier ?? '');
    final namaCtrl = TextEditingController(text: supplier?.namaSupplier ?? '');
    final alamatCtrl = TextEditingController(text: supplier?.alamat ?? '');
    final teleponCtrl = TextEditingController(text: supplier?.telepon ?? '');
    final keteranganCtrl =
        TextEditingController(text: supplier?.keterangan ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(supplier == null ? 'Tambah Supplier' : 'Edit Supplier'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: kodeCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Kode Supplier')),
              TextField(
                  controller: namaCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Nama Supplier')),
              TextField(
                  controller: alamatCtrl,
                  decoration: const InputDecoration(labelText: 'Alamat')),
              TextField(
                  controller: teleponCtrl,
                  decoration: const InputDecoration(labelText: 'Telepon')),
              TextField(
                  controller: keteranganCtrl,
                  decoration: const InputDecoration(labelText: 'Keterangan')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (supplier == null) {
                await db.insertSupplier(SuppliersCompanion(
                  kodeSupplier: Value(kodeCtrl.text),
                  namaSupplier: Value(namaCtrl.text),
                  alamat: Value(
                      alamatCtrl.text.isNotEmpty ? alamatCtrl.text : null),
                  telepon: Value(
                      teleponCtrl.text.isNotEmpty ? teleponCtrl.text : null),
                  keterangan: Value(keteranganCtrl.text.isNotEmpty
                      ? keteranganCtrl.text
                      : null),
                ));
              } else {
                await db.updateSupplier(
                  supplier.copyWith(
                    kodeSupplier:
                        kodeCtrl.text, // Non-nullable field, langsung string
                    namaSupplier:
                        namaCtrl.text, // Non-nullable field, langsung string
                    alamat: Value(alamatCtrl.text.isNotEmpty
                        ? alamatCtrl.text
                        : null), // Nullable field
                    telepon: Value(teleponCtrl.text.isNotEmpty
                        ? teleponCtrl.text
                        : null), // Nullable field
                    keterangan: Value(keteranganCtrl.text.isNotEmpty
                        ? keteranganCtrl.text
                        : null), // Nullable field
                  ),
                );
              }
              if (context.mounted) Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteSupplier(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Supplier'),
        content: const Text('Yakin ingin menghapus supplier ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await db.deleteSupplier(id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Supplier>>(
      future: db.getAllSuppliers(),
      builder: (context, snapshot) {
        final suppliers = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Manajemen Supplier'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () => _showForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(minWidth: 800),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          400, // agar area tabel tetap terlihat besar walau kosong
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.grey[200]),
                        dataRowColor: MaterialStateProperty.all(Colors.white),
                        border: TableBorder.all(color: Colors.grey),
                        columns: const [
                          DataColumn(label: Text('Kode')),
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Alamat')),
                          DataColumn(label: Text('Telepon')),
                          DataColumn(label: Text('Keterangan')),
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: suppliers.isNotEmpty
                            ? suppliers.map((s) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(s.kodeSupplier)),
                                    DataCell(Text(s.namaSupplier)),
                                    DataCell(Text(s.alamat ?? '-')),
                                    DataCell(Text(s.telepon ?? '-')),
                                    DataCell(Text(s.keterangan ?? '-')),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () =>
                                              _showForm(supplier: s),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _deleteSupplier(s.id),
                                        ),
                                      ],
                                    )),
                                  ],
                                );
                              }).toList()
                            : [],
                      ),
                    ),
                    if (suppliers.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Belum ada data supplier.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
