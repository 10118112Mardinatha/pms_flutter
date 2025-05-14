import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/log_activity_model.dart';
import 'package:pms_flutter/services/api_service.dart';

class RiwayatUserScreen extends StatefulWidget {
  const RiwayatUserScreen({super.key});

  @override
  State<RiwayatUserScreen> createState() => _RiwayatUserScreenState();
}

class _RiwayatUserScreenState extends State<RiwayatUserScreen> {
  List<LogActivity> logs = [];
  bool isLoading = true;
  String? usernameFilter;
  DateTime? dateFilter;

  final _usernameController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    dateFilter = DateTime.now(); // default: hari ini saja
    loadLogs();
  }

  void triggerSearchWithLoading() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => isLoading = true);
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() => isLoading = false);
      });
    });
  }

  Future<void> loadLogs() async {
    try {
      final data = await ApiService.fetchLogs(
        username:
            usernameFilter?.trim().isEmpty == true ? null : usernameFilter,
        date: dateFilter,
      );
      if (mounted) setState(() => logs = data);
    } catch (e) {
      debugPrint('Gagal memuat log: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateFilter ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => dateFilter = picked);
      triggerSearchWithLoading();
    }
  }

  void _clearFilters() {
    _usernameController.clear();
    final shouldReload = usernameFilter != null || dateFilter != null;

    setState(() {
      usernameFilter = null;
      dateFilter = DateTime.now(); // reset ke hari ini
    });

    if (shouldReload) triggerSearchWithLoading();
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: [
          SizedBox(
            width: 220,
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Cari Username',
                border: const OutlineInputBorder(),
                suffixIcon: usernameFilter?.isNotEmpty == true
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearFilters,
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() => usernameFilter = val.trim());
                triggerSearchWithLoading();
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today, size: 20),
            label: Text(
              dateFilter == null
                  ? 'Pilih Tanggal'
                  : DateFormat('dd-MM-yyyy').format(dateFilter!),
            ),
          ),
          if (dateFilter != null || (usernameFilter?.isNotEmpty ?? false))
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Filter'),
            ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          headingRowColor: MaterialStateProperty.all(Colors.blueGrey.shade50),
          columns: const [
            DataColumn(label: Text('Tanggal')),
            DataColumn(label: Text('Username')),
            DataColumn(label: Text('Aktivitas')),
          ],
          rows: logs
              .map(
                (log) => DataRow(cells: [
                  DataCell(Text(
                      DateFormat('dd-MM-yyyy HH:mm').format(log.timestamp))),
                  DataCell(Text(log.username)),
                  DataCell(Text(log.activity)),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Aktivitas User')),
      body: Column(
        children: [
          _buildFilterBar(),
          const Divider(height: 0),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : logs.isEmpty
                    ? const Center(
                        child: Text('Tidak ada data log untuk hari ini'))
                    : SingleChildScrollView(
                        child: _buildTable(),
                      ),
          ),
        ],
      ),
    );
  }
}
