import 'package:flutter/material.dart';

class AyarlarEkrani extends StatelessWidget {
  const AyarlarEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                _buildAyarSecenegi(Icons.person_outline, 'Profili Düzenle', true),
                const Divider(height: 1),
                _buildAyarSecenegi(Icons.lock_outline, 'Şifre Değiştir', true),
                const Divider(height: 1),
                _buildAyarSecenegi(Icons.palette_outlined, 'Uygulama Teması (Karanlık/Aydınlık)', true),
                const Divider(height: 1),
                _buildAyarSecenegi(Icons.language, 'Dil', true, trailingText: 'Türkçe'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyarSecenegi(IconData icon, String title, bool hasArrow, {String? trailingText}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) Text(trailingText, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(width: 8),
          if (hasArrow) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {
        print("$title tıklandı");
      },
    );
  }
}