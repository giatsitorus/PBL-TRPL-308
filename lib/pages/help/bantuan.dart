import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4C53A5), // Warna ungu kebiruan
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Pertanyaan Umum',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C53A5),
            ),
          ),
          const SizedBox(height: 10),

          // Pertanyaan 1
          helpTile(
            'Bagaimana cara membuat akun?',
            'Untuk membuat akun, hubungi administrator aplikasi. Hanya administrator yang dapat membuat akun pengguna.',
          ),

          // Pertanyaan 2
          helpTile(
            'Bagaimana cara mengganti kata sandi?',
            'Anda dapat mengganti kata sandi melalui menu "Pengaturan Keamanan" di halaman pengaturan aplikasi.',
          ),

          // Pertanyaan 3
          helpTile(
            'Bagaimana cara mengakses proyek saya?',
            'Proyek Anda dapat diakses melalui halaman "Project" di menu utama aplikasi.',
          ),

          // Pertanyaan 4
          helpTile(
            'Bagaimana jika saya tidak menerima notifikasi?',
            'Pastikan notifikasi aplikasi diaktifkan melalui pengaturan perangkat Anda.',
          ),

          const SizedBox(height: 20),

          // Tombol Kontak Support
          ElevatedButton.icon(
            onPressed: () {
              // Tambahkan logika untuk menghubungi support
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C53A5), // Warna ungu kebiruan
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.email, color: Colors.white),
            label: const Text(
              'Hubungi Support',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk tile bantuan
  Widget helpTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFBEBEBE), // Shadow abu-abu lembut
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4C53A5), // Warna ungu kebiruan
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
