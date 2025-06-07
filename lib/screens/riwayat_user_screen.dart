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
  List<LogActivity> paginatedLogs = [];

  bool isLoading = true;
  String? usernameFilter;
  DateTime? dateFilter;

  final _usernameController = TextEditingController();
  Timer? _debounce;

  int currentPage = 1;
  int rowsPerPage = 10;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    dateFilter = DateTime.now();
    loadLogs();
  }

  void triggerSearchWithLoading() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => isLoading = true);
      Future.delayed(const Duration(milliseconds: 400), () {
        loadLogs();
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
      if (mounted) {
        setState(() {
          logs = data;
          currentPage = 1;
          totalPages = (logs.length / rowsPerPage).ceil();
          _paginate();
        });
      }
    } catch (e) {
      debugPrint('Gagal memuat log: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _paginate() {
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, logs.length);
    paginatedLogs = logs.sublist(start, end);
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
      dateFilter = DateTime.now();
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
            width: 240,
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: '🔍 Cari Username',
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade100,
              foregroundColor: Colors.black87,
            ),
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today, size: 20),
            label: Text(
              dateFilter == null
                  ? 'Pilih Tanggal'
                  : DateFormat('dd-MM-yyyy').format(dateFilter!),
            ),
          ),
          if ((usernameFilter?.isNotEmpty ?? false))
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (tetap)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Expanded(
                    flex: 1,
                    child: Text('No',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text('Tanggal',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 3,
                    child: Text('Username',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 5,
                    child: Text('Aktivitas',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 0),

          // Body scrollable secara horizontal dan vertikal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 800, // Sesuaikan sesuai kebutuhan
              child: ListView.separated(
                separatorBuilder: (_, __) => const Divider(height: 0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paginatedLogs.length,
                itemBuilder: (context, index) {
                  final log = paginatedLogs[index];
                  final number = ((currentPage - 1) * rowsPerPage) + index + 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Text(number.toString())),
                        Expanded(
                            flex: 2,
                            child: Text(DateFormat('dd-MM-yyyy HH:mm')
                                .format(log.timestamp))),
                        Expanded(flex: 3, child: Text(log.username)),
                        Expanded(flex: 5, child: Text(log.activity)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('Tampilkan: '),
              DropdownButton<int>(
                value: rowsPerPage,
                items: [10, 20, 50]
                    .map((val) =>
                        DropdownMenuItem(value: val, child: Text('$val')))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      rowsPerPage = val;
                      currentPage = 1;
                      totalPages = (logs.length / rowsPerPage).ceil();
                      _paginate();
                    });
                  }
                },
              ),
              const Text(' entri per halaman'),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 1
                    ? () {
                        setState(() {
                          currentPage--;
                          _paginate();
                        });
                      }
                    : null,
              ),
              Text('Halaman $currentPage dari $totalPages'),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPages
                    ? () {
                        setState(() {
                          currentPage++;
                          _paginate();
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
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
      appBar: AppBar(
        title: const Text('📜 Riwayat Aktivitas User'),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          const Divider(height: 0),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : logs.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada data log untuk hari ini',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : SingleChildScrollView(child: _buildTable()),
          ),
          if (!isLoading && logs.isNotEmpty) _buildPaginationControls(),
        ],
      ),
    );
  }
}
