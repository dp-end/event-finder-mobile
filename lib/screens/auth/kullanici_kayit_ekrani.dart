import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class KullaniciKayitEkrani extends StatelessWidget {
  const KullaniciKayitEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Kaydı')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CustomTextField(hint: 'Ad Soyad', icon: Icons.person_outline), const SizedBox(height: 16),
          const CustomTextField(hint: 'E-posta', icon: Icons.email_outlined), const SizedBox(height: 16),
          const CustomTextField(hint: 'Telefon Numarası', icon: Icons.phone_outlined), const SizedBox(height: 16),
          const CustomTextField(hint: 'Doğum Tarihi', icon: Icons.calendar_today), const SizedBox(height: 16),
          _buildDropdown(context), const SizedBox(height: 16),
          _buildDropdown2(context), const SizedBox(height: 16),
          const CustomTextField(hint: 'Şifre', icon: Icons.lock_outline, isPassword: true), const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false), // Kayıt olunca Girişe dön
            child: const Text('Kayıt Ol', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(prefixIcon: const Icon(Icons.account_balance_outlined, color: Colors.grey), filled: true, fillColor: isDark ? Colors.grey[850] : Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
      hint: const Text('Üniversite Seçimi'),
      items: const [DropdownMenuItem(value: '1', child: Text('Akdeniz Üniversitesi')), DropdownMenuItem(value: '2', child: Text('Diğer'))],
      onChanged: (val) {},
    );
  }
  Widget _buildDropdown2(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(prefixIcon: const Icon(Icons.person, color: Colors.grey), filled: true, fillColor: isDark ? Colors.grey[850] : Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
      hint: const Text('Cinsiyet Seçimi'),
      items: const [DropdownMenuItem(value: '1', child: Text('Erkek')), DropdownMenuItem(value: '2', child: Text('Kadın'))],
      onChanged: (val) {},
    );
  }
}