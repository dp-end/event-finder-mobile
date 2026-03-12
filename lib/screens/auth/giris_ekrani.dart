import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class GirisEkrani extends StatelessWidget {
  const GirisEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              
              // ŞEFFAF LOGO: Artık o çirkin kare kutu yok!
              Image.asset(
                'assets/logo.png',
                height: 140, // Biraz daha büyüterek daha vurucu hale getirdik
              ),
              
              const SizedBox(height: 16),
              const Text(
                'Event Finder', 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                )
              ),
              const SizedBox(height: 50),
              
              const CustomTextField(
                hint: 'E-posta Adresi', 
                icon: Icons.email_outlined
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hint: 'Şifre', 
                icon: Icons.lock_outline, 
                isPassword: true
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text(
                    'Şifremi Unuttum?', 
                    style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)
                  ),
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
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: const Text(
                    'Giriş Yap', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16), 
                      child: Text('VEYA', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
                    ),
                    Expanded(child: Divider())
                  ]
                ),
              ),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/signup-select'),
                  child: const Text(
                    'Kayıt Ol', 
                    style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}