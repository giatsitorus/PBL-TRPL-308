import 'package:flutter/material.dart';

class TwoFactorPage extends StatelessWidget {
  const TwoFactorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Autentikasi 2 Faktor'),
        backgroundColor: const Color(0xFF4C53A5),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan Kode OTP',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Kode OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika verifikasi kode OTP
                String enteredOtp = otpController.text;
                if (enteredOtp == "123456") {
                  // Contoh sukses
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('2FA Berhasil Dikonfirmasi')),
                  );
                  Navigator.pop(context);
                } else {
                  // Contoh gagal
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kode OTP Salah')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C53A5),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Verifikasi'),
            ),
          ],
        ),
      ),
    );
  }
}
