import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan', 
          style: TextStyle(color: Colors.white), // Judul putih
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C53A5), // Warna header ungu kebiruan
        iconTheme: const IconThemeData(color: Colors.white), // Panah back putih
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Menu dengan jarak yang sama
          menuTile(Icons.person, 'Akun Saya', () {
            Navigator.pushNamed(context, '/profile');
          }),
          menuTile(Icons.security, 'Pengaturan Keamanan', () {
            Navigator.pushNamed(context, '/security-settings');
          }),
          menuTile(Icons.help_outline, 'Pusat Bantuan', () {
            Navigator.pushNamed(context, '/bantuan');
          }),
          menuTile(Icons.article_outlined, 'Kebijakan Privasi', () {
            Navigator.pushNamed(context, '/privacypolicy');
          }),
          menuTile(Icons.info_outline, 'Tentang Aplikasi', () {
            Navigator.pushNamed(context, '/about-app');
          }),

          const SizedBox(height: 20),

          // Tombol Logout
          ElevatedButton(
            onPressed: () async {
              await _logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C53A5), // Warna ungu
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),

          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Version 1.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Hapus status login
    // Arahkan pengguna kembali ke halaman login
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget menuTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // Jarak antar menu
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFBEBEBE), // Shadow abu-abu lebih lembut
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF4C53A5)), // Ikon ungu kebiruan
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey), // Tanda panah abu-abu
        onTap: onTap,
      ),
    );
  }
}