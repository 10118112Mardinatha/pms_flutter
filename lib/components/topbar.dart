import 'package:flutter/material.dart';
import '../../models/user_model.dart'; // Ganti sesuai path kamu

class TopBar extends StatelessWidget {
  final UserModel user;

  const TopBar({super.key, required this.user});

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
                'Hi, ${user.username ?? 'User'}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                user.role ?? 'Role',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit_profile':
                      // TODO: tampilkan form edit profile
                      break;
                    case 'change_password':
                      // TODO: tampilkan form ganti password
                      break;
                    case 'logout':
                      Navigator.of(context).pop(); // logout sederhana
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
                  backgroundImage: AssetImage(
                    user.avatar ?? 'assets/images/user_avatar.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
