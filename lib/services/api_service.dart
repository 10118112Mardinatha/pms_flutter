import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pms_flutter/models/barang_model.dart';
import 'package:pms_flutter/models/log_activity_model.dart';
import 'package:pms_flutter/models/pembelian_model.dart';
import 'package:pms_flutter/models/pembeliantmp_model.dart';
import 'package:pms_flutter/models/penjualan_model.dart';
import 'package:pms_flutter/models/penjualantmp_model.dart';
import 'package:pms_flutter/models/resep_model.dart';
import 'package:pms_flutter/models/reseptmp_model.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<String> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('ip') ?? ''; // fallback IP
    return 'http://$ip:8080';
  }

  // ====================== SUPPLIER ======================
  static Future<http.Response> fetchAllSuppliers() async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/supplier/');
    return await http.get(url);
  }

  static Future<List<dynamic>> searchSupplier(String keyword) async {
    final baseUrl = await _getBaseUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/supplier/cari/$keyword'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // return List<dynamic>
    } else {
      throw Exception('Gagal mengambil supplier');
    }
  }

  static Future<http.Response> postSupplier(Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/supplier/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchSupplierByKode(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/supplier/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updateSupplier(
      String kode, Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/supplier/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deleteSupplier(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/supplier/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

//IMPORT
  static Future<http.Response> importSupplierFromExcel(File file) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/supplier/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> importDoctorFromExcel(File file) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/doctor/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> importPelangganFromExcel(File file) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pelanggan/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> importRakFromExcel(File file) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/rak/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> importBarangFromExcel(File file) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/barang/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  // ====================== USER ======================
  static Future<UserModel?> login(String username, String password) async {
    final baseUrl = await _getBaseUrl();
    final res = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(res.body));
    }
    return null;
  }

  static Future<bool> updateUser({
    required int id,
    String? username,
    String? password,
    String? avatarPath,
  }) async {
    final baseUrl = await _getBaseUrl();
    final uri = Uri.parse('$baseUrl/user/$id');

    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    if (password != null) body['password'] = password;
    if (avatarPath != null) body['avatar'] = avatarPath;

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  static Future<List<UserModel>> fetchUsers() async {
    final baseUrl = await _getBaseUrl();
    final res = await http.get(Uri.parse('$baseUrl/user/'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<UserModel?> addUser(UserModel user) async {
    final baseUrl = await _getBaseUrl();
    final res = await http.post(
      Uri.parse('$baseUrl/user/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(res.body));
    }
    return null;
  }

  static Future<bool> deleteUser(int id) async {
    final baseUrl = await _getBaseUrl();
    final res = await http.delete(Uri.parse('$baseUrl/user/$id'));
    return res.statusCode == 200;
  }

  static Future<UserModel?> getUserById(String id) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/user/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      return null;
    }
  }

  static Future<bool> verifyPassword(int id, String password) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/user/verify');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'password': password}),
    );
    return response.statusCode == 200;
  }

//LOG
  static Future<void> logActivity(int userId, String action) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/log/log'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'action': action,
      }),
    );

    if (response.statusCode != 200) {
      debugPrint('Gagal menyimpan log aktivitas: ${response.body}');
      throw Exception('Gagal menyimpan log aktivitas');
    }
  }

  static Future<List<LogActivity>> fetchLogs({
    String? username,
    DateTime? date,
  }) async {
    final baseUrl = await _getBaseUrl();
    final queryParams = <String, String>{};
    if (username != null && username.isNotEmpty) {
      queryParams['username'] = username;
    }
    if (date != null) {
      queryParams['date'] = DateFormat('yyyy-MM-dd').format(date);
    }

    final uri =
        Uri.parse('$baseUrl/log/').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => LogActivity.fromJson(e)).toList();
      } else {
        throw Exception('Respon bukan List');
      }
    } else {
      throw Exception('Gagal memuat log aktivitas: ${response.statusCode}');
    }
  }

  static Future<List<ResepModel>> resepfilter({
    String? noRak,
    DateTime? date,
    String? namarak,
  }) async {
    final baseUrl = await _getBaseUrl();
    final queryParams = <String, String>{};
    if (noRak != null && noRak.isNotEmpty) {
      queryParams['kodeRak'] = noRak;
    }
    if (namarak != null && namarak.isNotEmpty) {
      queryParams['namaRak'] = namarak;
    }
    if (date != null) {
      queryParams['date'] = DateFormat('yyyy-MM-dd').format(date);
    }

    final uri =
        Uri.parse('$baseUrl/resep/').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => ResepModel.fromJson(e)).toList();
      } else {
        throw Exception('Respon bukan List');
      }
    } else {
      throw Exception(
          'Gagal memuat data Rak aktivitas: ${response.statusCode}');
    }
  }

  // ====================== DOKTER

  static Future<http.Response> fetchAllDokter() async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/doctor/');
    return await http.get(url);
  }

  static Future<List<dynamic>> searchDoctor(String keyword) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/doctor/cari/$keyword'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // return List<dynamic>
    } else {
      throw Exception('Gagal mengambil dcotor');
    }
  }

  static Future<http.Response> postDokter(Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/doctor/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchDokterByKode(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/doctor/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updateDokter(
      String kode, Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/doctor/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deleteDokter(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/doctor/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  //RAK
  static Future<http.Response> fetchAllRak() async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/rak/');
    return await http.get(url);
  }

  static Future<List<dynamic>> searchRak(String keyword) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/rak/cari/$keyword'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // return List<dynamic>
    } else {
      throw Exception('Gagal mengambil rak');
    }
  }

  static Future<http.Response> postRak(Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/rak/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchRakByKode(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/rak/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updateRak(
      String kode, Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/rak/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deleteRak(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/rak/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  //Barang
  static Future<http.Response> fetchAllBarang() async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/barang/');
    return await http.get(url);
  }

  static Future<BarangModel?> fetchBarangByKodefodiscon(String kode) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/barang/$kode'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BarangModel.fromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> searchBarang(String keyword) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/barang/cari/$keyword'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // return List<dynamic>
    } else {
      throw Exception('Gagal mengambil rak');
    }
  }

  static Future<String> generateKodeBarang() async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/barang/generatekode/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['kodeBarang']; // ✅ jadi string
    } else {
      throw Exception('Gagal ambil kode');
    }
  }

  static Future<http.Response> postBarang(Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/barang/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchBarangByKode(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/barang/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updateBarang(
      String kode, Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/barang/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deleteBarang(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/barang/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  //Pelanggan
  static Future<http.Response> fetchAllPelanggan() async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pelanggan/');
    return await http.get(url);
  }

  static Future<List<dynamic>> searchPelanggan(String keyword) async {
    final baseUrl = await _getBaseUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/pelanggan/cari/$keyword'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // return List<dynamic>
    } else {
      throw Exception('Gagal mengambil pelanggan');
    }
  }

  static Future<http.Response> postPelanggan(Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pelanggan/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchPelangganByKode(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pelanggan/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updatePelanggan(
      String kode, Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pelanggan/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deletePelanggan(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pelanggan/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }
  //pembaliantmp

  static Future<String> generatenofakturpembelian() async {
    final baseUrl = await _getBaseUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/pembeliantmp/generatenofaktur/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['noFaktur']; // ✅ jadi string
    } else {
      throw Exception('Gagal ambil kode');
    }
  }

  static Future<http.Response> fetchAllPembelian() async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembelian/');
    return await http.get(url);
  }

  static Future<List<PembelianModel>> fetchAllPembelianlap() async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembelian/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PembelianModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pembelian');
    }
  }

  static Future<List<PenjualanModel>> fetchAllPenjualanlap() async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/penjualan/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PenjualanModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pembelian');
    }
  }

  static Future<List<ResepModel>> fetchAllReseplap() async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/resep/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ResepModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pembelian');
    }
  }

  static Future<http.Response> postPembelianTmp(
      Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembeliantmp/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<List<PembelianTmpModel>> fetchPembelianTmp(String user) async {
    final baseUrl = await _getBaseUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/pembeliantmp/user/$user'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => PembelianTmpModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<http.Response> deletePembelianTmp(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembeliantmp/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  static Future<http.Response> updatePembelianTmp(
      String kode, Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembeliantmp/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> pindahPembelian(
      Map<String, dynamic> data, String user) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembeliantmp/pindah/$user');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<bool> cekNoFakturBelumAda(String noFaktur) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembelian/faktur/$noFaktur');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          return false;
        } else {
          return true;
        }
      }
    } catch (e) {
      print('Error saat cek noFaktur: $e');
    }

    return false;
  }

  static Future<int> getTotalHargaPembelianTmp(String username) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembeliantmp/user/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      int total = 0;

      for (var item in data) {
        total += (item['totalHarga'] ?? 0) as int;
      }

      return total;
    } else {
      throw Exception('Gagal memuat data pembelian sementara');
    }
  }

  static Future<http.Response> deletePembelianTmpUser(String user) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembeliantmp/user/$user');
    return http.delete(url);
  }

  //resep
  static Future<http.Response> postResepTmp(Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/reseptmp/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> updateResepTmp(
      String kode, Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/reseptmp/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<List<ResepTmpModel>> fetchResepTmp(String user) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/reseptmp/user/$user'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ResepTmpModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<http.Response> deleteResepTmp(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/reseptmp/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  static Future<http.Response> pindahResep(
      Map<String, dynamic> data, String user) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/reseptmp/pindah/$user');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<String> generatenoResep() async {
    final baseUrl = await _getBaseUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/reseptmp/generatenoresep/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['noResep']; // ✅ jadi string
    } else {
      throw Exception('Gagal ambil kode');
    }
  }

  static Future<http.Response> deleteResepTmpUser(String user) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/reseptmp/user/$user');
    return http.delete(url);
  }

  static Future<bool> cekNoResepBelumAda(String noFaktur) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/resep/$noFaktur');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          return false;
        } else {
          return true;
        }
      }
    } catch (e) {
      print('Error saat cek noFaktur: $e');
    }

    return false;
  }

  //penjualan

  static Future<http.Response> postPenjualanTmp(
      Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/penjualantmp/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<void> updatePenjualanByNoFaktur(
      String noFaktur, Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/penjualan/nofaktur/$noFaktur');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update penjualan');
    }
  }

  static Future<String> generatenofakturpenjualan() async {
    final baseUrl = await _getBaseUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/penjualantmp/generatenofaktur/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['noFaktur']; // ✅ jadi string
    } else {
      throw Exception('Gagal ambil kode');
    }
  }

  static Future<void> updateStatusPenjualan(
      String noFaktur, String status) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.put(
      Uri.parse('$baseUrl/penjualan/status/$noFaktur'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update status penjualan');
    }
  }

  static Future<http.Response> pindahPenjualan(
      Map<String, dynamic> data, String user) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/penjualantmp/pindah/$user');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<List<PenjualanTmpModel>> fetchPenjualanTmp(String user) async {
    final baseUrl = await _getBaseUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/penjualantmp/user/$user'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => PenjualanTmpModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<http.Response> updatePenjualanTmp(
      String kode, Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/penjualantmp/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deletePenjualanTmpUser(String user) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/penjualantmp/user/$user');
    return http.delete(url);
  }

  static Future<http.Response> deletePenjualanTmp(String kode) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/penjualantmp/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  static Future<int> getTotalHargaPenjualanTmp(String username) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/penjualantmp/user/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      int total = 0;

      for (var item in data) {
        total += (item['totalHargaSetelahDisc'] ?? 0) as int;
      }

      return total;
    } else {
      throw Exception('Gagal memuat data pembelian sementara');
    }
  }

  static Future<bool> insertResepToPenjualanTmp({
    required String kodePelanggan,
    required String username,
  }) async {
    final baseUrl = await _getBaseUrl();
    final url =
        Uri.parse('$baseUrl/penjualantmp/fromresep/$kodePelanggan/$username');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      print('Resep berhasil dimasukkan ke penjualantmp');
      return true;
    } else {
      print('Gagal: ${response.body}');
      return false;
    }
  }

  static Future<List<PembelianModel>> getPembelian() async {
    final baseUrl = await _getBaseUrl();
    final res = await http.get(Uri.parse('$baseUrl/pembelian'));
    if (res.statusCode == 200) {
      final List jsonData = jsonDecode(res.body);
      return jsonData.map((e) => PembelianModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data pembelian');
    }
  }

  /// Tambahkan pembelian jika diperlukan nanti
  static Future<http.Response> addPembelian(Map<String, dynamic> data) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/pembelian');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<bool> cekNoFakturPenjualanBelumAda(String noFaktur) async {
    final baseUrl = await _getBaseUrl();
    final url = Uri.parse('$baseUrl/penjualan/$noFaktur');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          return false;
        } else {
          return true;
        }
      }
    } catch (e) {
      print('Error saat cek noFaktur: $e');
    }

    return false;
  }
}
