import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class SifremiUnuttumEkrani extends StatelessWidget {
  const SifremiUnuttumEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şifremi Unuttum')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_reset, size: 80, color: Color(0xFF1D4ED8)),
            const SizedBox(height: 24),
            const Text('Şifrenizi sıfırlamak için kayıtlı e-posta adresinizi girin.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const CustomTextField(hint: 'E-posta Adresi', icon: Icons.email_outlined),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), 
                onPressed: () => Navigator.pop(context), 
                child: const Text('Sıfırlama Linki Gönder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              )
            ),
          ],
        ),
      ),
    );
  }
}