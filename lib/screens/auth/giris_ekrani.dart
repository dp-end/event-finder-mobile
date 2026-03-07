import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class GirisEkrani extends StatelessWidget {
  const GirisEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF1D4ED8),
                child: Text('C', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'serif')),
              ),
              const SizedBox(height: 16),
              const Text('CampusHub', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'serif')),
              const SizedBox(height: 50),
              
              const CustomTextField(hint: 'E-posta Adresi', icon: Icons.email_outlined),
              const SizedBox(height: 16),
              const CustomTextField(hint: 'Şifre', icon: Icons.lock_outline, isPassword: true),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot-password'), // Şifremi Unuttum'a gider
                  child: const Text('Şifremi Unuttum?', style: TextStyle(color: Color(0xFF1D4ED8))),
                ),
              ),
              
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8), 
                    foregroundColor: Colors.white, 
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'), // Ana Sayfaya gider (Geri dönülemez)
                  child: const Text('Giriş Yap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('VEYA', style: TextStyle(color: Colors.grey))), Expanded(child: Divider())]),
              ),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/signup-select'), // Kayıt Seçimine gider
                  child: const Text('Kayıt Ol', style: TextStyle(fontSize: 16, color: Colors.black87)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}