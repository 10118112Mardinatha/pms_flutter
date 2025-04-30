import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pms_flutter/database/app_database.dart';
import 'package:pms_flutter/models/user_model.dart';
import '../screens/login_screen.dart';
import 'dart:io'; // supaya bisa tampil image file lokal

class TopBar extends StatefulWidget {
  final UserModel user;
  final AppDatabase db;

  const TopBar({super.key, required this.user, required this.db});

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
    final userFromDb = await widget.db.getUserById(int.parse(userData.id));
    if (userFromDb != null) {
      setState(() {
        userData = UserModel.fromUser(userFromDb);
      });
    }
  }

  Future<String?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.local_pharmacy, color: Colors.blue, size: 26),
          const SizedBox(width: 8),
          const Text(
            'Pharmacy PMS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                'Hi, ${userData.username ?? 'User'}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Text(
                userData.role ?? 'Role',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(width: 16),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                offset: const Offset(0, 50),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit_profile',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit Profil'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'change_password',
                    child: ListTile(
                      leading: Icon(Icons.lock),
                      title: Text('Ganti Password'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: userData.avatar != null
                      ? FileImage(File(userData.avatar!))
                      : const AssetImage('assets/images/user_avatar.png')
                          as ImageProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final usernameController = TextEditingController(text: userData.username);
    String? tempImagePath = userData.avatar;
    final passwordController = TextEditingController();
    bool isPasswordVisible = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
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
                          setStateDialog(() {
                            tempImagePath = pickedPath;
                          });
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
                          onPressed: () {
                            setStateDialog(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = await widget.db.verifyPassword(
                      int.parse(userData.id),
                      passwordController.text.trim(),
                    );

                    if (isValid) {
                      await widget.db.updateUsername(
                        int.parse(userData.id),
                        usernameController.text.trim(),
                      );
                      if (tempImagePath != null) {
                        await widget.db.updateAvatar(
                          int.parse(userData.id),
                          tempImagePath!,
                        );
                      }
                      await loadUser();
                      Navigator.of(context).pop(); // Tutup dialog
                    } else {
                      _showErrorMessage('Password salah');
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    bool isOldVisible = false;
    bool isNewVisible = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Ganti Password'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: oldPasswordController,
                      obscureText: !isOldVisible,
                      decoration: InputDecoration(
                        labelText: 'Password Lama',
                        suffixIcon: IconButton(
                          icon: Icon(isOldVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setStateDialog(() {
                              isOldVisible = !isOldVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: newPasswordController,
                      obscureText: !isNewVisible,
                      decoration: InputDecoration(
                        labelText: 'Password Baru',
                        suffixIcon: IconButton(
                          icon: Icon(isNewVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setStateDialog(() {
                              isNewVisible = !isNewVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (newPasswordController.text.trim().length < 6) {
                      _showErrorMessage('Password baru minimal 6 karakter');
                      return;
                    }

                    final isValid = await widget.db.verifyPassword(
                      int.parse(userData.id),
                      oldPasswordController.text.trim(),
                    );

                    if (isValid) {
                      await widget.db.updatePassword(
                        int.parse(userData.id),
                        newPasswordController.text.trim(),
                      );
                      await loadUser();
                      Navigator.of(context).pop(); // Tutup dialog
                    } else {
                      _showErrorMessage('Password lama salah');
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
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
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final isValid = await widget.db.verifyPassword(
                    int.parse(userData.id),
                    passwordController.text.trim(),
                  );
                  Navigator.of(context).pop(isValid);
                },
                child: const Text('Logout'),
              ),
            ],
          );
        });
      },
    );

    if (confirmed == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(db: widget.db)),
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
