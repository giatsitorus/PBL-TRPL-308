import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pbl/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Arahkan pengguna ke halaman yang sesuai jika sudah login
      Navigator.pushReplacementNamed(context, '/home'); // Ganti dengan halaman yang sesuai
    }
  }

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    Navigator.pushReplacementNamed(context, '/adminhome'); // Halaman admin

    try {
      final response = await Dio().post(baseUrl + '/api/login', data: {
        'email': email,
        'password': password,
      });
      // Navigator.pushReplacementNamed(context, '/adminhome'); // Halaman admin
      print("=============");
      print(response);

      // if (response.data['success']) {
      //   String role = response.data['data']['role']; // Ambil peran dari respons

      //   // Simpan status login di SharedPreferences
      //   final prefs = await SharedPreferences.getInstance();
      //   await prefs.setBool('isLoggedIn', true);
      //   await prefs.setString('role', role); // Simpan role jika perlu

      //   // Arahkan pengguna ke halaman yang sesuai berdasarkan peran
      //   if (role == 'internal') {
      //     Navigator.pushReplacementNamed(context, '/adminhome'); // Halaman admin
      //   } else if (role == 'technician') {
      //     Navigator.pushReplacementNamed(context, '/technicianhome'); // Halaman teknisi
      //   } else if (role == 'public') {
      //     Navigator.pushReplacementNamed(context, '/userhome'); // Halaman publik
      //   } else {
      //     // Jika peran tidak dikenali, tampilkan pesan kesalahan
      //     _showErrorDialog('Peran tidak dikenali.');
      //   }
      // } else {
      //   // Tampilkan pesan error
      //   _showErrorDialog(response.data['message'] ?? 'Email atau password salah.');
      // }
    } catch (e) {
      // Tampilkan pesan error jika terjadi kesalahan saat melakukan permintaan
      // _showErrorDialog('Terjadi kesalahan saat mencoba login.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Gagal'),
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
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xFF4C53A5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Masuk ke akun Anda',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      // Input email
                      TextFormField(
                        controller: _emailController,
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
                      ),
                      const SizedBox(height: 20),
                      // Input password
                      TextFormField(
                        controller: _passwordController,
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
                      ),
                      const SizedBox(height: 30),
                      // Tombol Login
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 20),
                      // Link ke halaman Register
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Belum punya akun? ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}