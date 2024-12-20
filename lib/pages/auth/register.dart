import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String role = 'internal'; // Default role, bisa diubah sesuai kebutuhan
  String phone = '';

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password dan konfirmasi password tidak cocok')),
        );
        return;
      }

      try {
        final response = await Dio().post('http://192.168.6.64:3000/api/register', data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'phone': phone,
        });

        if (response.data['success']) {
          // Tampilkan pesan sukses dan navigasi ke halaman login
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User  berhasil didaftarkan')));
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          // Tampilkan pesan kesalahan
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.data['message'])));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4C53A5), Color(0xFF2E2A72)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo aplikasi
                    Image.asset(
                      'assets/icon/icon.png', // Pastikan path file benar
                      width: 120,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Daftarkan akun Anda untuk melanjutkan',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    // Input nama
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Nama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Input email
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Input password
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                                                hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Input konfirmasi password
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Konfirmasi Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Input nomor telepon
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Nomor Telepon',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor telepon tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        phone = value;
                      },
                    ),
                    const SizedBox(height: 30),
                    // Tombol Register
                    ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4C53A5), // Warna ungu untuk teks tombol
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Register'),
                    ),
                    const SizedBox(height: 20),
                    // Link ke halaman Login
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Sudah punya akun? Login',
                        style: TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}