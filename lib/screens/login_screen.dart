import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pms_flutter/services/api_service.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIp();
  }

  Future<void> _loadIp() async {
    final pre = await SharedPreferences.getInstance();
    final String ip = pre.getString('ip') ?? '';
    setState(() {
      _ipController.text = ip;
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final iphost = _ipController.text;

    try {
      final response = await http.post(
        Uri.parse('http://${iphost}:8080/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parsing akses dengan aman
        final akses = (() {
          final raw = data['akses'];
          if (raw == null) return [];
          if (raw is List) return List<String>.from(raw);
          if (raw is String) {
            try {
              final decoded = jsonDecode(raw);
              if (decoded is List) return List<String>.from(decoded);
            } catch (_) {}
          }
          return [];
        })();

        final userModel = UserModel(
          id: data['id'],
          password: data['password'],
          username: data['username'],
          role: data['role'],
          aktif: data['aktif'],
          avatar: data['avatar'],
          akses: List<String>.from(akses),
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userModel.id);
        await prefs.setString('username', userModel.username);
        await prefs.setString('role', userModel.role);
        await prefs.setBool('aktif', userModel.aktif);
        await prefs.setString('ip', _ipController.text.trim());
        await prefs.setString('akses', jsonEncode(userModel.akses));
        if (userModel.avatar != null) {
          await prefs.setString('avatar', userModel.avatar!);
        }

        await ApiService.logActivity(
          userModel.id,
          'Login berhasil sebagai ${userModel.role}',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardScreen(user: userModel)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Login gagal username atau password salah'),
            backgroundColor: Colors.red),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pharmacy_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      StreamBuilder<DateTime>(
                        stream: Stream.periodic(
                            const Duration(seconds: 1), (_) => DateTime.now()),
                        builder: (context, snapshot) {
                          final now = snapshot.data ?? DateTime.now();
                          final formattedDate =
                              '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
                          final formattedTime =
                              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

                          return Column(
                            children: [
                              Text(
                                formattedDate,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                formattedTime,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onFieldSubmitted: (_) => _login(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ipController,
                        decoration: const InputDecoration(
                          labelText: 'IP Address Host',
                          prefixIcon: Icon(Icons.wifi),
                          border: OutlineInputBorder(),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'IP Address wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blue.shade600,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
