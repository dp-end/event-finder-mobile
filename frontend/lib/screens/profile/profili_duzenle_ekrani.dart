import 'package:flutter/material.dart';

class ProfilDuzenleEkrani extends StatefulWidget {
  const ProfilDuzenleEkrani({super.key});

  @override
  State<ProfilDuzenleEkrani> createState() => _ProfilDuzenleEkraniState();
}

class _ProfilDuzenleEkraniState extends State<ProfilDuzenleEkrani> {
  // Gerçek bir uygulamadaki gibi detaylı alanlar
  final _adController = TextEditingController(text: 'Burak Büyukelçi');
  final _epostaController = TextEditingController(text: 'burak.buyukelci@gmail.com');
  final _telefonController = TextEditingController(text: '+90 555 123 4567');
  final _unvController = TextEditingController(text: 'Akdeniz Üniversitesi');
  final _bolumController = TextEditingController(text: 'Bilgisayar Mühendisliği');
  final _hakkimdaController = TextEditingController(text: 'Backend geliştirme ve UI/UX tasarımı ile ilgileniyorum. Yeni etkinlikler keşfetmek için buradayım.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profili Düzenle', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil başarıyla güncellendi!'), backgroundColor: Colors.green));
            },
            child: const Text('Kaydet', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // PROFİL FOTOĞRAFI ALANI
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1D4ED8), width: 3),
                      image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=800'), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFF1D4ED8), shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            // FORM ALANLARI
            _buildTextField('Ad Soyad', Icons.person_outline, _adController),
            const SizedBox(height: 16),
            _buildTextField('E-posta', Icons.email_outlined, _epostaController),
            const SizedBox(height: 16),
            _buildTextField('Telefon', Icons.phone_outlined, _telefonController),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: _buildTextField('Üniversite', Icons.school_outlined, _unvController)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField('Bölüm', Icons.book_outlined, _bolumController),
            const SizedBox(height: 16),
            
            TextField(
              controller: _hakkimdaController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Hakkımda', alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Tasarımı temiz tutmak için yardımcı metod
  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}