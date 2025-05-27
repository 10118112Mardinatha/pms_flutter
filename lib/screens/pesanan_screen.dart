import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/barang_model.dart';
import 'package:pms_flutter/models/pesanantmp_model.dart';
import 'package:pms_flutter/models/reseptmp_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';

class PesananScreen extends StatefulWidget {
  final UserModel user;
  const PesananScreen({super.key, required this.user});

  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  List<PesananTmpModel> allPesanantmp = [];
  DateTime tanggal = DateTime.now();
  final TextEditingController _namaPemesanController = TextEditingController();
  final TextEditingController _noPesananController = TextEditingController();
  BarangModel? selectedBarang;
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
//formutama
  List<BarangModel> barangs = [];
  List<BarangModel> filteredBarangs = [];
  List<UserModel> users = [];
  String searchField = 'Nama Barang';
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  final List<int> _rowsPerPageOptions = [10, 20, 30];
  final searchOptions = [
    'Kelompok',
    'Nama Barang',
  ];

  @override
  void initState() {
    super.initState();
    widget.user.id;
    _loadPesanan();
  }

  Future<void> _loadPesanan() async {
    final noPesananbaru = await ApiService.generateNoPesanan();
    final data = await ApiService.fetchPesananTmp(widget.user.username);

    setState(() {
      allPesanantmp = data;
      _noPesananController.text = noPesananbaru;
    });
    final response = await ApiService.fetchAllBarang();
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      setState(() {
        barangs = jsonList.map((json) => BarangModel.fromJson(json)).toList();

        // Awalnya filteredSuppliers sama dengan semua supplier
        filteredBarangs = List.from(barangs);
        _currentPage = 0; // Reset ke halaman pertama
      });
    } else {
      // Tangani error jika perlu
      print('Gagal memuat data supplier: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentPage = 0;

  int get _totalPages => (filteredBarangs.length / _rowsPerPage).ceil();

  List<BarangModel> get _paginatedBarangs {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (_currentPage + 1) * _rowsPerPage;
    final cappedEndIndex =
        endIndex > filteredBarangs.length ? filteredBarangs.length : endIndex;

    return filteredBarangs.sublist(startIndex, cappedEndIndex);
  }

  void _applySearch() {
    setState(() {
      filteredBarangs = barangs.where((s) {
        final value = switch (searchField) {
          'Kelompok' => s.kelompok!,
          'Nama Barang' => s.namaBarang!,
          _ => '',
        };
        return value.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  Future<void> prosesSimpan() async {
    final nopesanan = _noPesananController.text;
    final namapelanggan = _namaPemesanController.text;

    if (nopesanan.isEmpty || namapelanggan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tanggal.toString())),
      );
      return;
    }
    final data = {
      'noFaktur': nopesanan,
      'noPesanan': nopesanan,
      'namaPemesan': namapelanggan,
      'tanggal': tanggal.toIso8601String(),
    };
    try {
      late http.Response response;
      response = await ApiService.pindahPesanan(data, widget.user.username);

      ///jgn lupa

      if (!mounted) return; // <-- ini cek awal, sebelum lanjut
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil disimpan')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        // Refresh tampilan
        _namaPemesanController.clear();
        _loadPesanan();
      } else if (response.statusCode == 404) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.body)),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal menyimpan data. Code: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> prosesbatal() async {
    // Bersihkan tabel pembelianstmp
    late http.Response respon;
    respon =
        await ApiService.deletePesananTmpUser(widget.user.username); // jgn lupa
    // Reset form input

    tanggal = DateTime.now();
    _namaPemesanController.clear;

    _loadPesanan();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _deletePesanan(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus'),
        content: const Text('Yakin ingin menghapus barang ini?'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.close, color: Colors.grey),
            label: const Text('Batal', style: TextStyle(color: Colors.grey)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Hapus', style: TextStyle(color: Colors.red)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final response = await ApiService.deletePesananTmp(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _loadPesanan(); // <-- refresh data di layar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Barang di pesanan ini berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus')),
        );
      }
    }
  }

  Future<void> _showForm({PesananTmpModel? data, BarangModel? data2}) async {
    final formKey = GlobalKey<FormState>();
    final kodebarangCtrl =
        TextEditingController(text: data?.kodeBarang ?? data2!.kodeBarang);
    final namabarangCtrl =
        TextEditingController(text: data?.namaBarang ?? data2!.namaBarang);
    final jumlahCtrl =
        TextEditingController(text: data?.jumlahJual.toString() ?? '');
    BarangModel? pilihBarang =
        await ApiService.fetchBarangByKodefodiscon(kodebarangCtrl.text);

    Future<void> _submitForm() async {
      if (formKey.currentState!.validate()) {
        if (data != null) {
          int sisaStokupdate = pilihBarang?.stokAktual ?? 0;
          int jumlahbel = int.tryParse(jumlahCtrl.text) ?? 0;
          if (jumlahbel > sisaStokupdate) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Stok Tidak Cukup'),
                content: Text(
                    'Stok tersedia hanya $sisaStokupdate, tetapi jumlah jual $jumlahbel.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'))
                ],
              ),
            );
            return;
          }
          int jumlah = int.tryParse(jumlahCtrl.text) ?? 0;
          int totalhar = data.hargaJual * jumlah;
          int jualdis = data.hargaJual;
          int totalstlhdisc = jualdis * jumlah;
          int totaldis = totalhar - totalstlhdisc;
          final dat = {
            'id': data.id,
            'username': widget.user.username,
            'kodeBarang': kodebarangCtrl.text,
            'namaBarang': namabarangCtrl.text,
            'kelompok': data.kelompok,
            'satuan': data.satuan,
            'hargaBeli': data.hargaBeli,
            'hargaJual': data.hargaJual,
            'jualDiscon': jualdis,
            'jumlahJual': int.tryParse(jumlahCtrl.text),
            'totalHargaSebelumDisc': totalhar,
            'totalHargaSetelahDisc': totalstlhdisc,
            'totalDisc': totaldis,
            'status': 'menunggu'
          };

          try {
            final update =
                await ApiService.updatePesananTmp(data.id.toString(), dat);

            if (update.statusCode == 200 || update.statusCode == 201) {
              if (context.mounted) Navigator.pop(context);
              await _loadPesanan(); // refresh data
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal menyimpan data')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        } else if (data2 != null) {
          int sisaStokupdate = pilihBarang?.stokAktual ?? 0;
          int jumlahbel = int.tryParse(jumlahCtrl.text) ?? 0;
          if (jumlahbel > sisaStokupdate) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Stok Tidak Cukup'),
                content: Text(
                    'Stok tersedia hanya $sisaStokupdate, tetapi jumlah jual $jumlahbel.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'))
                ],
              ),
            );
            return;
          }
          int jumlah = int.tryParse(jumlahCtrl.text) ?? 0;
          int totalhar = data2.hargaJual * jumlah;
          int jualdis = data2.hargaJual;
          int totalstlhdisc = jualdis * jumlah;
          int totaldis = totalhar - totalstlhdisc;
          final dat2 = {
            'username': widget.user.username,
            'kodeBarang': kodebarangCtrl.text,
            'namaBarang': namabarangCtrl.text,
            'kelompok': data2.kelompok,
            'satuan': data2.satuan,
            'hargaBeli': data2.hargaBeli,
            'hargaJual': data2.hargaJual,
            'jualDiscon': jualdis,
            'jumlahJual': int.tryParse(jumlahCtrl.text),
            'totalHargaSebelumDisc': totalhar,
            'totalHargaSetelahDisc': totalstlhdisc,
            'totalDisc': totaldis,
            'status': 'menunggu',
          };
          try {
            final update = await ApiService.postPesananTmp(dat2);

            if (update.statusCode == 200 || update.statusCode == 201) {
              if (context.mounted) Navigator.pop(context);
              await _loadPesanan(); // refresh data
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal menyimpan data')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        }
      } else {
        print('Validasi gagal');
      }
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(data == null ? 'Tambah' : 'Edit'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: kodebarangCtrl,
                  decoration: InputDecoration(labelText: 'Kode barang'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: namabarangCtrl,
                  decoration: InputDecoration(labelText: 'Nama'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: jumlahCtrl,
                  decoration: InputDecoration(labelText: 'Jumlah'),
                  onFieldSubmitted: (_) => _submitForm(),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Wajib diisi tidak boleh kosong'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _submitForm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 3,
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === KOLOM KIRI ===
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📄 Pesanan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.7),
                  const SizedBox(height: 10),
                  Text(
                    'Pilih barang ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: searchField,
                        onChanged: (value) {
                          setState(() {
                            searchField = value!;
                            _applySearch();
                          });
                        },
                        items: searchOptions.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option,
                                style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        underline:
                            Container(height: 1, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(6),
                        dropdownColor: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 250,
                        height: 38,
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            hintText: 'Cari...',
                            hintStyle: const TextStyle(fontSize: 13),
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      searchText = '';
                                      _applySearch();
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                          ),
                          onChanged: (value) {
                            searchText = value;
                            _applySearch();
                          },
                        ),
                      ),
                    ],
                  ),

                  // Tabel barang + pagination
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 1300),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(
                                      Colors.blue[300]),
                                  dataRowColor:
                                      MaterialStateProperty.all(Colors.white),
                                  border: TableBorder.all(
                                      color: Colors.grey.shade300),
                                  headingRowHeight: 40,
                                  headingTextStyle: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  dataTextStyle: const TextStyle(fontSize: 13),
                                  columnSpacing: 10,
                                  columns: const [
                                    DataColumn(label: Text('No')),
                                    DataColumn(label: Text('Nama')),
                                    DataColumn(label: Text('Kelompok')),
                                    DataColumn(label: Text('Satuan')),
                                  ],
                                  rows: _paginatedBarangs
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final s = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          InkWell(
                                            onTap: () async {
                                              await _showForm(
                                                  data: null, data2: s);
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 16.0),
                                              child: Text(
                                                  '${_currentPage * _rowsPerPage + index + 1}'),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          InkWell(
                                            onTap: () async {
                                              await _showForm(
                                                  data: null, data2: s);
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 16.0),
                                              child: SizedBox(
                                                width: 150,
                                                child: Text(
                                                  s.namaBarang ?? '',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          InkWell(
                                            onTap: () async {
                                              await _showForm(
                                                  data: null, data2: s);
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 16.0),
                                              child: Text(s.kelompok ?? ''),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          InkWell(
                                            onTap: () async {
                                              await _showForm(
                                                  data: null, data2: s);
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 16.0),
                                              child: Text(s.satuan ?? ''),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Pagination
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Baris per halaman:'),
                                const SizedBox(width: 8),
                                DropdownButton<int>(
                                  value: _rowsPerPage,
                                  onChanged: (value) {
                                    setState(() {
                                      _rowsPerPage = value!;
                                      _currentPage = 0;
                                    });
                                  },
                                  items: _rowsPerPageOptions
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text('$e')))
                                      .toList(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: _currentPage > 0
                                      ? () {
                                          setState(() {
                                            _currentPage--;
                                          });
                                        }
                                      : null,
                                ),
                                Text(
                                    'Halaman ${_currentPage + 1} dari $_totalPages'),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: _currentPage < _totalPages - 1
                                      ? () {
                                          setState(() {
                                            _currentPage++;
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16), // Spasi antar kolom
            // === KOLOM KANAN ===
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📦 Daftar Pesanan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: prosesbatal,
                            icon: const Icon(Icons.close,
                                color: Colors.white, size: 20),
                            label: const Text('Batal',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              minimumSize: const Size(100, 40),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 4,
                              shadowColor: Colors.redAccent.withOpacity(0.4),
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton.icon(
                            onPressed:
                                prosesSimpan, // Ganti dengan fungsi simpan kalau ada
                            icon: const Icon(Icons.save,
                                color: Colors.white, size: 20),
                            label: const Text('Simpan',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              minimumSize: const Size(130, 40),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 8,
                              shadowColor: Colors.blueAccent.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(
                        height: 35,
                        width: 200,
                        child: TextFormField(
                          controller: _noPesananController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            border: OutlineInputBorder(),
                            labelText: 'No Pesanan',
                          ),
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        height: 35,
                        width: 200,
                        child: TextFormField(
                          controller: _namaPemesanController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nama',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.blue.shade300),
                        dataRowColor: MaterialStateProperty.all(Colors.white),
                        border: TableBorder.all(color: Colors.grey.shade300),
                        headingRowHeight: 40,
                        headingTextStyle: const TextStyle(fontSize: 12),
                        dataTextStyle: const TextStyle(fontSize: 11),
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Kelompok')),
                          DataColumn(label: Text('Satuan')),
                          DataColumn(label: Text('Jumlah')),
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: allPesanantmp.map((p) {
                          return DataRow(
                            cells: [
                              DataCell(SizedBox(
                                width: 150,
                                child: Text(p.namaBarang,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              )),
                              DataCell(Text(p.kelompok)),
                              DataCell(Text(p.satuan)),
                              DataCell(Text((p.jumlahJual).toString())),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Edit Data',
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () =>
                                        _showForm(data: p, data2: null),
                                  ),
                                  IconButton(
                                    tooltip: 'Hapus Data',
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deletePesanan(p.id.toString()),
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
