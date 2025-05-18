import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pms_flutter/database/app_database.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahUserScreen extends StatefulWidget {
  final int currentUserId;
  const TambahUserScreen({super.key, required this.currentUserId});

  @override
  State<TambahUserScreen> createState() => _TambahUserScreenState();
}

class _TambahUserScreenState extends State<TambahUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _selectedRole;
  List<UserModel> users = [];

  File? _pickedImage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _ipAddress;

  final List<String> _roles = ['admin', 'apoteker'];

  @override
  void initState() {
    super.initState();
    _loadSavedIp();
  }

  Future<void> _loadSavedIp() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipAddress = prefs.getString('ip');
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> getSavedIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ip');
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        id: 0,
        username: _usernameController.text,
        password: _passwordController.text,
        role: _selectedRole!,
        aktif: true,
        avatar: _pickedImage?.path,
      );

      try {
        await ApiService.addUser(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User berhasil ditambahkan')),
        );
        await ApiService.logActivity(
            widget.currentUserId, 'Menambah Userr ${_usernameController.text}');
        _formKey.currentState!.reset();
        _usernameController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        setState(() {
          _pickedImage = null;
          _selectedRole = null;
        });
        users = await ApiService.fetchUsers();
        _showUserDialog();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan user: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _showUserDialog() async {
    users = await ApiService.fetchUsers();
    final prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString('ip');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Manajemen User'),
          content: SizedBox(
            width: double.maxFinite,
            child: users.isEmpty
                ? const Text('Belum ada user.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              user.avatar != null && user.avatar!.isNotEmpty
                                  ? FileImage(File(user.avatar!))
                                  : const AssetImage(
                                          'assets/images/user_avatar.png')
                                      as ImageProvider,
                        ),
                        title: Text(user.username),
                        subtitle: Text(user.role),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            Tooltip(
                              message: user.aktif
                                  ? 'Nonaktifkan User'
                                  : 'Aktifkan User',
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                        scale: animation, child: child),
                                child: Switch(
                                  key: ValueKey(user.aktif),
                                  value: user.aktif,
                                  onChanged: user.id == widget.currentUserId
                                      ? null
                                      : (_) async {
                                          final updatedAktif = !user.aktif;
                                          final response = await http.put(
                                            Uri.parse(
                                                'http://${ip}:8080/user/${user.id}'),
                                            headers: {
                                              'Content-Type': 'application/json'
                                            },
                                            body: jsonEncode(
                                                {'aktif': updatedAktif}),
                                          );
                                          if (response.statusCode == 200) {
                                            await ApiService.logActivity(
                                              widget.currentUserId,
                                              'Mengubah status user ${user.username} menjadi ${updatedAktif ? 'Aktif' : 'Nonaktif'}',
                                            );
                                            Navigator.pop(context);
                                            _showUserDialog();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Gagal memperbarui status user')),
                                            );
                                          }
                                        },
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              value: user.role,
                              items: ['admin', 'apoteker'].map((role) {
                                return DropdownMenuItem(
                                    value: role, child: Text(role));
                              }).toList(),
                              onChanged: user.id == widget.currentUserId
                                  ? null
                                  : (newRole) async {
                                      if (newRole != null &&
                                          newRole != user.role) {
                                        final response = await http.put(
                                          Uri.parse(
                                              'http://${ip}:8080/user/${user.id}'),
                                          headers: {
                                            'Content-Type': 'application/json'
                                          },
                                          body: jsonEncode({
                                            'role': newRole,
                                            'aktif': user.aktif,
                                          }),
                                        );

                                        if (response.statusCode == 200) {
                                          await ApiService.logActivity(
                                            widget.currentUserId,
                                            'Mengubah role user ${user.username} menjadi $newRole',
                                          );
                                          Navigator.pop(context);
                                          _showUserDialog();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Gagal mengubah role')),
                                          );
                                        }
                                      }
                                    },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: user.id == widget.currentUserId
                                  ? 'Tidak bisa menghapus user sendiri'
                                  : 'Hapus User',
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: user.id == widget.currentUserId
                                  ? null
                                  : () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Hapus User'),
                                          content: const Text(
                                              'Yakin ingin menghapus user ini?'),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, false),
                                                  icon: const Icon(Icons.cancel,
                                                      color: Colors.blueGrey),
                                                  label: const Text(
                                                    'Batal',
                                                    style: TextStyle(
                                                        color: Colors.blueGrey),
                                                  ),
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                ElevatedButton.icon(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, true),
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.white),
                                                  label: const Text('Hapus'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        final response =
                                            await ApiService.deleteUser(
                                                user.id);
                                        if (response.statusCode == 200) {
                                          await ApiService.logActivity(
                                            widget.currentUserId,
                                            'Menghapus user ${user.username}',
                                          );
                                          Navigator.pop(context);
                                          _showUserDialog();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Gagal menghapus user')),
                                          );
                                        }
                                      }
                                    },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text('Tutup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _trySubmitIfValid() {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      _submitForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah User'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showUserDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : const AssetImage('assets/images/user_avatar.png')
                          as ImageProvider,
                  child: _pickedImage == null
                      ? const Icon(Icons.add_a_photo,
                          size: 40, color: Colors.white70)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.isEmpty
                    ? 'Username tidak boleh kosong'
                    : null,
                onFieldSubmitted: (_) => _trySubmitIfValid(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  } else if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _trySubmitIfValid(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _trySubmitIfValid(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  } else if (value != _passwordController.text) {
                    return 'Konfirmasi password tidak sesuai';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _selectedRole = value),
                validator: (value) => value == null ? 'Pilih role' : null,
                onSaved: (_) => _trySubmitIfValid(), // optional
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Simpan User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: Colors.blueAccent.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
