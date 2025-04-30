import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pms_flutter/database/app_database.dart';
import 'package:pms_flutter/models/user_model.dart';

class TambahUserScreen extends StatefulWidget {
  final AppDatabase database;
  final int currentUserId;
  const TambahUserScreen(
      {super.key, required this.database, required this.currentUserId});

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
  File? _pickedImage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _roles = ['admin', 'apoteker'];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newUser = UsersCompanion(
        username: Value(_usernameController.text),
        password: Value(_passwordController.text),
        role: Value(_selectedRole!),
        aktif: const Value(true),
        avatar: Value(_pickedImage?.path),
      );

      try {
        await widget.database.insertUser(newUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User berhasil ditambahkan')),
        );

        _formKey.currentState!.reset();
        setState(() {
          _pickedImage = null;
          _selectedRole = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan user: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _showUserDialog() async {
    final users = await widget.database.getAllUsers();

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
                                      ? null // disable switch untuk user sendiri
                                      : (_) async {
                                          final updated =
                                              user.copyWith(aktif: !user.aktif);
                                          await widget.database
                                              .updateUser(updated);
                                          setState(() {});
                                          Navigator.pop(context);
                                          _showUserDialog(); // refresh dialog
                                        },
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: user.id == widget.currentUserId
                                  ? 'Tidak bisa menghapus user sendiri'
                                  : 'Hapus User',
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: user.id == widget.currentUserId
                                  ? null // disable tombol
                                  : () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Hapus User'),
                                          content: const Text(
                                              'Yakin ingin menghapus user ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx, false),
                                              child: const Text('Batal'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx, true),
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await widget.database
                                            .deleteUser(user.id);
                                        setState(() {});
                                        Navigator.pop(context); // keluar dulu
                                        Future.delayed(
                                            Duration.zero, _showUserDialog);
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
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup')),
          ],
        );
      },
    );
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
                validator: (value) => value == null || value.isEmpty
                    ? 'Username tidak boleh kosong'
                    : null,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  } else if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
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
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Simpan User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
