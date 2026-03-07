import 'package:flutter/material.dart';

class KayitSecimEkrani extends StatelessWidget {
  const KayitSecimEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hesap Türü Seçin')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSecimButonu(context, 'Kullanıcı Kaydı', 'Öğrenci veya personel olarak katıl', Icons.person_outline, '/user-signup'),
            const SizedBox(height: 24),
            _buildSecimButonu(context, 'Topluluk/Kulüp Kaydı', 'Resmi kulüp hesabı oluştur', Icons.groups_outlined, '/club-signup'),
          ],
        ),
      ),
    );
  }

  Widget _buildSecimButonu(BuildContext context, String baslik, String altBaslik, IconData ikon, String rota) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, rota),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundColor: const Color(0xFF1D4ED8).withOpacity(0.1), child: Icon(ikon, size: 30, color: const Color(0xFF1D4ED8))),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(baslik, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(altBaslik, style: TextStyle(color: Colors.grey[600]))])),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}