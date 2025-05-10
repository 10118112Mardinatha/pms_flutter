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

//IMPORT
  static Future<http.Response> importSupplierFromExcel(File file) async {
    final url = Uri.parse('$baseUrl/supplier/import');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  ///
  static Future<http.Response> deleteSupplier(String kode) {
    final url = Uri.parse('$baseUrl/supplier/$kode');
    return http.delete(url); // Pastikan API mendukung method DELETE
  }

  // ====================== PELANGGAN ======================
  static Future<http.Response> fetchAllPelanggan() async {
    final url = Uri.parse('$baseUrl/pelanggan');
    return await http.get(url);
  }

  static Future<http.Response> postPelanggan(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/pelanggan');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
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

  // ====================== DOKTER, RESEP, DLL ======================
  // Buat sesuai kebutuhan, contoh:
  static Future<http.Response> fetchAllDokter() async {
    final url = Uri.parse('$baseUrl/doctor');
    return await http.get(url);
  }
}
