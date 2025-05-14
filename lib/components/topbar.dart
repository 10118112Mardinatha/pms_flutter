import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pms_flutter/models/user_model.dart';
import 'package:pms_flutter/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login_screen.dart';

class TopBar extends StatefulWidget {
  final UserModel user;
  const TopBar({super.key, required this.user});

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late UserModel userData;

  @override
  void initState() {
    super.initState();
    userData = widget.user;
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final userFromApi = await ApiService.getUserById(userData.id.toString());
      if (userFromApi != null) {
        setState(() => userData = userFromApi);
      }
    } catch (e) {
      debugPrint('Gagal load user dari API: $e');
    }
  }

  Future<String?> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    return picked?.path;
  }

  void _showEditProfileDialog() {
    final usernameController = TextEditingController(text: userData.username);
    String? tempImagePath = userData.avatar;
    final passwordController = TextEditingController();
    bool isPasswordVisible = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Edit Profil'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final pickedPath = await _pickImage();
                      if (pickedPath != null) {
                        setStateDialog(() => tempImagePath = pickedPath);
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: tempImagePath != null
                          ? FileImage(File(tempImagePath!))
                          : const AssetImage('assets/images/user_avatar.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Klik gambar untuk ganti'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Masukkan Password',
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setStateDialog(
                            () => isPasswordVisible = !isPasswordVisible),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final isValid = await ApiService.verifyPassword(
                    userData.id,
                    passwordController.text.trim(),
                  );

                  if (!isValid) {
                    _showErrorMessage('Password salah');
                    return;
                  }

                  await ApiService.updateUser(
                    id: userData.id,
                    username: usernameController.text.trim(),
                    avatarPath: tempImagePath,
                  );

                  await loadUser();
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        });
      },
    );
  }

  void _showChangePasswordDialog() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    bool isOldVisible = false;
    bool isNewVisible = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Ganti Password'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: oldPassCtrl,
                  obscureText: !isOldVisible,
                  decoration: InputDecoration(
                    labelText: 'Password Lama',
                    suffixIcon: IconButton(
                      icon: Icon(isOldVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setStateDialog(() => isOldVisible = !isOldVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPassCtrl,
                  obscureText: !isNewVisible,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    suffixIcon: IconButton(
                      icon: Icon(isNewVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setStateDialog(() => isNewVisible = !isNewVisible),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (newPassCtrl.text.trim().length < 6) {
                  _showErrorMessage('Password baru minimal 6 karakter');
                  return;
                }

                final isValid = await ApiService.verifyPassword(
                  userData.id!,
                  oldPassCtrl.text.trim(),
                );

                if (!isValid) {
                  _showErrorMessage('Password lama salah');
                  return;
                }

                await ApiService.updateUser(
                  id: userData.id!,
                  password: newPassCtrl.text.trim(),
                );

                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() async {
    final passwordController = TextEditingController();
    bool isPasswordVisible = false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Masukkan Password',
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setStateDialog(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final inputPassword = passwordController.text.trim();

                  // Cek apakah password cocok atau menggunakan 'admin123'
                  final isValid = await ApiService.verifyPassword(
                        userData.id,
                        inputPassword,
                      ) ||
                      inputPassword == 'admin123';

                  if (!isValid) {
                    _showErrorMessage('Password salah');
                  }

                  Navigator.pop(context, isValid);
                },
                child: const Text('Logout'),
              ),
            ],
          );
        });
      },
    );

    if (confirmed == true && context.mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: Colors.white,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.blueAccent, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Row(
              children: [
                const Icon(Icons.local_hospital,
                    color: Colors.blueAccent, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Pharmacy Management System',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hi, ${userData.username ?? 'User'} 👋',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      userData.role ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit_profile':
                        _showEditProfileDialog();
                        break;
                      case 'change_password':
                        _showChangePasswordDialog();
                        break;
                      case 'logout':
                        _confirmLogout();
                        break;
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  offset: const Offset(0, 50),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit_profile',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit Profil'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'change_password',
                      child: ListTile(
                        leading: Icon(Icons.lock_outline),
                        title: Text('Ganti Password'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: ListTile(
                        leading: Icon(Icons.logout_outlined),
                        title: Text('Logout'),
                      ),
                    ),
                  ],
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: userData.avatar != null &&
                              File(userData.avatar!).existsSync()
                          ? FileImage(File(userData.avatar!))
                          : const AssetImage('assets/images/user_avatar.png')
                              as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
