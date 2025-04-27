import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../database/app_database.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class PenjualanScreen extends StatefulWidget {
  final AppDatabase database;

  const PenjualanScreen({super.key, required this.database});

  @override
  State<PenjualanScreen> createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  late AppDatabase db;
  List<Penjualan> allPenjualan = [];
  bool iscek = false;

  @override
  void initState() {
    super.initState();
    db = widget.database;
    _loadPenjualan();
  }

  Future<void> _loadPenjualan() async {
    final data = await db.getAllPenjualans();
    setState(() {
      allPenjualan = data;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> ProsesPenjualan() async {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Penjualan',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                ElevatedButton.icon(
                  onPressed: ProsesPenjualan,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan/Bayar'),
                ),
              ],
            ),
            Divider(
              thickness: 0.7,
              color: Colors.black,
            ),
            Text(
              'Rp. ',
              style: TextStyle(fontSize: 40),
            ),
            Divider(
              thickness: 0.7,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30,
                  width: 200,
                  child: TextFormField(
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: 'No Faktur',
                    ),
                  ),
                ),
                Row(children: [
                  Checkbox(
                      value: iscek,
                      onChanged: (bool? newvalue) {
                        setState(() {
                          iscek = newvalue ?? false;
                        });
                      }),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 30,
                    width: 200,
                    child: TextFormField(
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: 'No Faktur',
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
