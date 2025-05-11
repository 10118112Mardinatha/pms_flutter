import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://192.168.1.6:8080'; // Ganti sesuai IP server LAN

  // ====================== SUPPLIER ======================
  static Future<http.Response> fetchAllSuppliers() async {
    final url = Uri.parse('$baseUrl/supplier/');
    return await http.get(url);
  }

  static Future<http.Response> postSupplier(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/supplier/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchSupplierByKode(String kode) async {
    final url = Uri.parse('$baseUrl/supplier/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updateSupplier(
      String kode, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/supplier/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deleteSupplier(String kode) {
    final url = Uri.parse('$baseUrl/supplier/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

//IMPORT
  static Future<http.Response> importSupplierFromExcel(File file) async {
    final url = Uri.parse('$baseUrl/supplier/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> importDoctorFromExcel(File file) async {
    final url = Uri.parse('$baseUrl/doctor/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> importPelangganFromExcel(File file) async {
    final url = Uri.parse('$baseUrl/pelanggan/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> importRakFromExcel(File file) async {
    final url = Uri.parse('$baseUrl/rak/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> importBarangFromExcel(File file) async {
    final url = Uri.parse('$baseUrl/barang/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  // ====================== USER ======================
  static Future<http.Response> loginUser(
      String username, String password, Bool aktif) async {
    final url = Uri.parse('$baseUrl/user/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'aktif': aktif,
      }),
    );
  }

  // ====================== DOKTER

  static Future<http.Response> fetchAllDokter() async {
    final url = Uri.parse('$baseUrl/doctor/');
    return await http.get(url);
  }

  static Future<http.Response> postDokter(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/doctor/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchDokterByKode(String kode) async {
    final url = Uri.parse('$baseUrl/doctor/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updateDokter(
      String kode, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/doctor/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deleteDokter(String kode) {
    final url = Uri.parse('$baseUrl/doctor/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  //RAK
  static Future<http.Response> fetchAllRak() async {
    final url = Uri.parse('$baseUrl/rak/');
    return await http.get(url);
  }

  static Future<List<dynamic>> searchRak(String keyword) async {
    final response = await http.get(Uri.parse('$baseUrl/rak/$keyword'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // return List<dynamic>
    } else {
      throw Exception('Gagal mengambil rak');
    }
  }

  static Future<http.Response> postRak(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/rak/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchRakByKode(String kode) async {
    final url = Uri.parse('$baseUrl/rak/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updateRak(
      String kode, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/rak/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deleteRak(String kode) {
    final url = Uri.parse('$baseUrl/rak/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  //Barang
  static Future<http.Response> fetchAllBarang() async {
    final url = Uri.parse('$baseUrl/barang/');
    return await http.get(url);
  }

  static Future<http.Response> postBarang(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/barang/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchBarangByKode(String kode) async {
    final url = Uri.parse('$baseUrl/barang/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updateBarang(
      String kode, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/barang/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deleteBarang(String kode) {
    final url = Uri.parse('$baseUrl/barang/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  //Pelanggan
  static Future<http.Response> fetchAllPelanggan() async {
    final url = Uri.parse('$baseUrl/pelanggan/');
    return await http.get(url);
  }

  static Future<http.Response> postPelanggan(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/pelanggan/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> fetchPelangganByKode(String kode) async {
    final url = Uri.parse('$baseUrl/pelanggan/$kode');
    return await http.get(url);
  }

  static Future<http.Response> updatePelanggan(
      String kode, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/pelanggan/$kode');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deletePelanggan(String kode) {
    final url = Uri.parse('$baseUrl/pelanggan/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }
}
