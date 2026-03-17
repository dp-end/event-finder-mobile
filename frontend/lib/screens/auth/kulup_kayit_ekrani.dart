import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class KulupKayitEkrani extends StatelessWidget {
  const KulupKayitEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kulüp Kaydı')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CustomTextField(hint: 'Kulüp Adı', icon: Icons.groups_outlined), const SizedBox(height: 16),
          const CustomTextField(hint: 'Kulüp E-postası', icon: Icons.email_outlined), const SizedBox(height: 16),
          const CustomTextField(hint: 'Danışman Hoca', icon: Icons.school_outlined), const SizedBox(height: 16),
          const CustomTextField(hint: 'Kulüp Telefonu', icon: Icons.phone_outlined), const SizedBox(height: 16),
          const CustomTextField(hint: 'Referans Numarası', icon: Icons.tag), const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(prefixIcon: const Icon(Icons.account_balance_outlined, color: Colors.grey), filled: true, fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
            items: const [DropdownMenuItem(value: '1', child: Text('Akdeniz Üniversitesi'))],
            onChanged: (val) {},
            hint: const Text('Üniversite Seçimi'),
          ),
          const SizedBox(height: 16),
          const CustomTextField(hint: 'Şifre', icon: Icons.lock_outline, isPassword: true), const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
            child: const Text('Kulüp Olarak Kayıt Ol', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}