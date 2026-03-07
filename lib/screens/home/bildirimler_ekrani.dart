import 'package:flutter/material.dart';

class BildirimlerEkrani extends StatelessWidget {
  const BildirimlerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Bildirimler', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        children: [
          _buildBildirim(
            icon: Icons.favorite_border, iconColor: Colors.red,
            title: 'Sarah Yıllık Hackathon etkinliğindeki yorumunu beğendi',
            time: '2 dk önce', okunmadi: true,
            // Yorum/Beğeni bildirimi -> Etkinlik detayına gider
            onTap: () => Navigator.pushNamed(context, '/event-detail'),
          ),
          _buildBildirim(
            icon: Icons.event, iconColor: Colors.green,
            title: 'Tech Innovators Club yeni bir etkinlik paylaştı',
            time: '1 saat önce', okunmadi: true,
            // Yeni etkinlik -> Etkinlik detayına gider
            onTap: () => Navigator.pushNamed(context, '/event-detail'),
          ),
          _buildBildirim(
            icon: Icons.notifications_active_outlined, iconColor: Colors.orange,
            title: 'Basketbol Şampiyonası yarın başlıyor!',
            time: '3 saat önce', okunmadi: true,
            onTap: () => Navigator.pushNamed(context, '/event-detail'),
          ),
          _buildBildirim(
            icon: Icons.chat_bubble_outline, iconColor: Colors.blue,
            title: 'Alex yorumuna yanıt verdi',
            time: '5 saat önce', okunmadi: false,
            onTap: () => Navigator.pushNamed(context, '/event-detail'),
          ),
          _buildBildirim(
            icon: Icons.event_available, iconColor: Colors.teal,
            title: 'Yapay Zeka Zirvesi rezervasyonun onaylandı',
            time: '2 gün önce', okunmadi: false,
            // Bilet/Rezervasyon bildirimi -> Biletlerim sayfasına gider
            onTap: () => Navigator.pushNamed(context, '/my-tickets'),
          ),
        ],
      ),
    );
  }

  // YENİ: onTap parametresi eklendi ve InkWell ile sarmalandı
  Widget _buildBildirim({required IconData icon, required Color iconColor, required String title, required String time, required bool okunmadi, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent, // Tıklama efekti (Ripple) için Material kullandık
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: okunmadi ? const Color(0xFF1D4ED8).withOpacity(0.04) : Colors.transparent,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            title: Text(title, style: TextStyle(fontSize: 14, fontWeight: okunmadi ? FontWeight.bold : FontWeight.normal)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ),
            trailing: okunmadi ? const CircleAvatar(radius: 4, backgroundColor: Color(0xFF1D4ED8)) : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}