import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/barang_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/penjualan_model.dart';
import '../../services/api_service.dart';

class KasirPenjualanScreen extends StatefulWidget {
  final UserModel user;
  const KasirPenjualanScreen({super.key, required this.user});

  @override
  State<KasirPenjualanScreen> createState() => _KasirPenjualanScreenState();
}

class _KasirPenjualanScreenState extends State<KasirPenjualanScreen> {
  List<PenjualanModel> menunggu = [];

  bool isLoading = true;
  final _nofakturController = TextEditingController();
  final formatter =
      NumberFormat.decimalPattern('id'); // atau: NumberFormat("#,##0", "id_ID")
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  @override
  void initState() {
    super.initState();
    fetchMenungguData();
  }

  Future<void> fetchMenungguData() async {
    setState(() => isLoading = true);
    try {
      final all = await ApiService.fetchAllPenjualanlap();
      menunggu = all.where((p) => p.status == 'menunggu').toList();
    } catch (e) {
      debugPrint('Gagal memuat data penjualan: $e');
    }
    setState(() => isLoading = false);
  }

  void _showStrukPreview(List<PenjualanModel> items) {
    final formatRupiah =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    final totalSebelum = items.fold<double>(
        0, (sum, item) => sum + (item.totalHargaSebelumDisc ?? 0));
    final totalBayar = items.fold<double>(
        0, (sum, item) => sum + (item.totalHargaSetelahDisc ?? 0));
    final totalDiskon = totalSebelum - totalBayar;

    final now = DateTime.now();
    final formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
    final username = widget.user.username;
    _nofakturController.text = items.first.noFaktur;

    Future<void> bayar() async {
      await ApiService.updateStatusPenjualan(items.first.noFaktur, 'lunas');
      await _printStruk(items);
      if (context.mounted) Navigator.pop(context);
      fetchMenungguData();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Preview Struk'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Column(
                    children: [
                      Text('Apotek Segar',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Jl. S.Parman, Kavaleri 29, No. 24'),
                      Text('Kec. Langkai Kel. Pahandut Kota Palangka Raya'),
                      Text('Kalimantan Tengah , 74874'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(children: [
                      const Text('No Faktur'),
                      Text(': ${_nofakturController.text}'),
                    ]),
                    TableRow(children: [
                      const Text('Tanggal'),
                      Text(': $formattedDateTime'),
                    ]),
                    TableRow(children: [
                      const Text('Kasir'),
                      Text(': $username'),
                    ]),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 4),
                Table(
                  columnWidths: const {
                    0: FixedColumnWidth(30),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2),
                    3: FixedColumnWidth(50),
                    4: FixedColumnWidth(50),
                    5: FlexColumnWidth(2),
                    6: FlexColumnWidth(3),
                  },
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(),
                      children: [
                        Center(
                            child: Text('No',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('Nama',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('Harga',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Center(
                            child: Text('Satuan',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Center(
                            child: Text('Qty',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('Harga Diskon',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('Subtotal',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...items.asMap().entries.map((entry) {
                      final i = entry.key + 1;
                      final item = entry.value;
                      final harga = item.hargaJual ?? 0;
                      final diskon = item.jualDiscon ?? 0;
                      final qty = item.jumlahJual ?? 0;
                      final satuan = item.satuan ?? '';
                      final subtotal = diskon * qty;

                      return TableRow(
                        children: [
                          Center(child: Text('$i')),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Text(item.namaBarang ?? ''),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(formatRupiah.format(harga)),
                          ),
                          Center(child: Text(satuan)),
                          Center(child: Text('$qty')),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(formatRupiah.format(diskon)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(formatRupiah.format(subtotal)),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                const Divider(),
                Text('Total Harga   : ${formatRupiah.format(totalSebelum)}'),
                Text('Total Diskon  : ${formatRupiah.format(totalDiskon)}'),
                Text('Total Dibayar : ${formatRupiah.format(totalBayar)}'),
                const SizedBox(height: 10),
                const Divider(),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Terima kasih telah berbelanja di Apotek Segar. '
                      'Untuk keluhan atau pertanyaan terkait obat, silakan hubungi Apoteker kami. '
                      'Struk ini harap disimpan sebagai bukti pembelian.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: Colors.white,
                elevation: 5,
                shadowColor: Colors.blueAccent.withOpacity(0.6),
              ),
              icon: const Icon(Icons.payment, size: 20),
              label: const Text(
                'Bayar & Cetak',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
                ),
              ),
              onPressed: bayar,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<PenjualanModel>> get groupedByFaktur {
    final map = <String, List<PenjualanModel>>{};
    for (final item in menunggu) {
      map.putIfAbsent(item.noFaktur, () => []).add(item);
    }
    return map;
  }

  Future<void> _printStruk(List<PenjualanModel> items) async {
    final doc = pw.Document();
    final formatRupiah =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    final totalSebelum = items.fold<double>(
        0, (sum, item) => sum + (item.totalHargaSebelumDisc ?? 0));
    final totalBayar = items.fold<double>(
        0, (sum, item) => sum + (item.totalHargaSetelahDisc ?? 0));
    final totalDiskon = totalSebelum - totalBayar;

    final now = DateTime.now();
    final formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
    final username = widget.user.username;
    final noFaktur = _nofakturController.text = items.first.noFaktur;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Apotek Segar',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Jl. S.Parman, Kavaleri 29, No. 24'),
                    pw.Text('Kec. Langkai Kel. Pahandut Kota Palangka Raya'),
                    pw.Text('Kalimantan Tengah , 74874'),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('No Faktur : $noFaktur'),
              pw.Text('Tanggal   : $formattedDateTime'),
              pw.Text('Kasir     : $username'),
              pw.Divider(),

              // Tabel header
              pw.Row(
                children: [
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('No',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 3,
                      child: pw.Text('Nama',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text('Harga',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('Stn',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('Qty',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text('Disc',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text('Subttl',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ],
              ),

              pw.SizedBox(height: 4),

              // Tabel isi
              ...items.asMap().entries.map((entry) {
                final i = entry.key + 1;
                final item = entry.value;
                final harga = item.hargaJual ?? 0;
                final diskon = item.jualDiscon ?? 0;
                final qty = item.jumlahJual ?? 0;
                final satuan = item.satuan ?? '';
                final subtotal = diskon * qty;

                return pw.Row(
                  children: [
                    pw.Expanded(flex: 1, child: pw.Text('$i')),
                    pw.Expanded(flex: 3, child: pw.Text(item.namaBarang ?? '')),
                    pw.Expanded(
                        flex: 2, child: pw.Text(formatRupiah.format(harga))),
                    pw.Expanded(flex: 1, child: pw.Text(satuan)),
                    pw.Expanded(flex: 1, child: pw.Text('$qty')),
                    pw.Expanded(
                        flex: 2, child: pw.Text(formatRupiah.format(diskon))),
                    pw.Expanded(
                        flex: 2, child: pw.Text(formatRupiah.format(subtotal))),
                  ],
                );
              }).toList(),

              pw.Divider(),
              pw.Text('Total Harga   : ${formatRupiah.format(totalSebelum)}'),
              pw.Text('Total Diskon  : ${formatRupiah.format(totalDiskon)}'),
              pw.Text('Total Dibayar : ${formatRupiah.format(totalBayar)}'),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Center(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                  child: pw.Text(
                    'Terima kasih telah berbelanja di Apotek Segar. '
                    'Untuk keluhan atau pertanyaan terkait obat, silakan hubungi Apoteker kami. '
                    'Struk ini harap disimpan sebagai bukti pembelian.',
                    style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      fontSize:
                          9, // bisa kecilkan font supaya tidak terlalu dominan
                      color: PdfColors.grey600, // warna abu abu agak redup
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );

    // Logging aktivitas & cetak
    await ApiService.logActivity(
        widget.user.id, 'Melakukan pembayaran $noFaktur');

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Struk Penjualan',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Menu Kasir - Pembayaran')),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : menunggu.isEmpty
                ? const Center(child: Text('Tidak ada penjualan menunggu'))
                : ListView(
                    padding: const EdgeInsets.all(12),
                    children: groupedByFaktur.entries.map((entry) {
                      final faktur = entry.key;
                      final items = entry.value;
                      final status = items.first.status;
                      final totalBayar = items.fold<int>(
                          0, (sum, i) => sum + (i.totalHargaSetelahDisc ?? 0));
                      final tanggal = items.first.tanggalPenjualan;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Faktur: $faktur',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  'Tanggal: ${DateFormat('dd-MM-yyyy').format(tanggal)}'),
                              Text('Status: $status'),
                              const SizedBox(height: 12),

                              /// Tabel Header
                              Table(
                                columnWidths: const {
                                  0: FixedColumnWidth(40),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(1.2),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1),
                                  5: FlexColumnWidth(1),
                                  6: FlexColumnWidth(1.4),
                                  7: FixedColumnWidth(60),
                                },
                                border: TableBorder.all(
                                    color: Colors.grey.shade300),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200),
                                    children: const [
                                      Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text('No')),
                                      Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text('Barang')),
                                      Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text('Harga Jual')),
                                      Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text('Satuan')),
                                      Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text('Qty')),
                                      Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text('Harga Diskon')),
                                      Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text('Total Bayar')),
                                      Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text('Edit')),
                                    ],
                                  ),
                                  ...items.asMap().entries.map((entry) {
                                    final index = entry.key + 1;
                                    final item = entry.value;
                                    return TableRow(children: [
                                      Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Text('$index')),
                                      Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Text(item.namaBarang)),
                                      Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Text(
                                              'Rp ${formatter.format(item.hargaJual)}')),
                                      Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Text('${item.satuan ?? ''}')),
                                      Padding(
                                          padding: const EdgeInsets.all(6),
                                          child:
                                              Text('${item.jumlahJual ?? 0}')),
                                      Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Text(
                                              'Rp ${formatter.format(item.jualDiscon)}')),
                                      Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Text(
                                              'Rp ${formatter.format(item.totalHargaSetelahDisc)}')),
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () =>
                                              _showEditDialog(item),
                                          tooltip: 'Edit item',
                                        ),
                                      ),
                                    ]);
                                  }),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Total Bayar: Rp ${formatter.format(totalBayar)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 10),

                              /// Tombol Bayar & Cetak
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () => _showStrukPreview(items),
                                  icon: const Icon(Icons.receipt_long_outlined,
                                      size: 20),
                                  label: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 14),
                                    child: Text(
                                      'Bayar & Cetak',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ));
  }

  Future<void> _showEditDialog(PenjualanModel penjualan) async {
    final formKey = GlobalKey<FormState>();
    final jumlahCtrl =
        TextEditingController(text: penjualan.jumlahJual?.toString() ?? '0');
    final diskonCtrl =
        TextEditingController(text: penjualan.jualDiscon?.toString() ?? '0');
    BarangModel? pilihBarang =
        await ApiService.fetchBarangByKodefodiscon(penjualan.kodeBarang);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Penjualan'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: jumlahCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Jual',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Masukkan jumlah yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TypeAheadFormField<Map<String, dynamic>>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: diskonCtrl,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Jual Diskon',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    if (pilihBarang == null) return [];

                    final discs = <Map<String, dynamic>>[];

                    if (pilihBarang!.jualDisc1 != null &&
                        pilihBarang!.jualDisc1 != 0) {
                      discs.add({
                        'label': 'Diskon 1',
                        'value': pilihBarang!.jualDisc1
                      });
                    }
                    if (pilihBarang!.jualDisc2 != null &&
                        pilihBarang!.jualDisc2 != 0) {
                      discs.add({
                        'label': 'Diskon 2',
                        'value': pilihBarang!.jualDisc2
                      });
                    }
                    if (pilihBarang!.jualDisc3 != null &&
                        pilihBarang!.jualDisc3 != 0) {
                      discs.add({
                        'label': 'Diskon 3',
                        'value': pilihBarang!.jualDisc3
                      });
                    }
                    if (pilihBarang!.jualDisc4 != null &&
                        pilihBarang!.jualDisc4 != 0) {
                      discs.add({
                        'label': 'Diskon 4',
                        'value': pilihBarang!.jualDisc4
                      });
                    }

                    return discs
                        .where((d) => d['value'].toString().contains(pattern));
                  },
                  itemBuilder: (context, suggestion) {
                    final formatted =
                        currencyFormatter.format(suggestion['value']);
                    return ListTile(
                      title: Text(formatted),
                      subtitle: Text(suggestion['label']),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    diskonCtrl.text =
                        currencyFormatter.format(suggestion['value']);
                  },
                  noItemsFoundBuilder: (context) =>
                      Text('Diskon tidak tersedia'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final jumlahJual = int.tryParse(jumlahCtrl.text.trim()) ?? 0;
              final diskon =
                  int.tryParse(diskonCtrl.text.trim()) ?? penjualan.hargaJual;

              final totalHarga = penjualan.hargaJual * jumlahJual;
              final totalSetelahDiskon = jumlahJual * diskon;
              final totalDics = totalHarga - totalSetelahDiskon;

              final payload = {
                'noFaktur': penjualan.noFaktur,
                'kodePelanggan': penjualan.kodePelanggan,
                'namaPelanggan': penjualan.namaPelanggan,
                'kodeDoctor': penjualan.kodeDoctor,
                'namaDoctor': penjualan.namaDoctor,
                'tanggalPenjualan':
                    penjualan.tanggalPenjualan.toIso8601String(),
                'kodeBarang': penjualan.kodeBarang,
                'namaBarang': penjualan.namaBarang,
                'kelompok': penjualan.kelompok,
                'satuan': penjualan.satuan,
                'hargaBeli': penjualan.hargaBeli,
                'hargaJual': penjualan.hargaJual,
                'jualDiscon': diskon,
                'jumlahJual': jumlahJual,
                'totalHargaSebelumDisc': totalHarga,
                'totalHargaSetelahDisc': totalSetelahDiskon,
                'totalDisc': totalDics,
                'status': penjualan.status,
              };

              await ApiService.updatePenjualanByNoid(
                penjualan.id.toString(),
                payload,
              );
              await ApiService.logActivity(
                  widget.user.id, 'Melakukan edit pembayaran ${totalDics}');

              if (context.mounted) Navigator.pop(context);
              fetchMenungguData();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
