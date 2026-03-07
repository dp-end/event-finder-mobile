import 'package:flutter/material.dart';
import '../../widgets/etkinlik_karti.dart';

class KullaniciProfilEkrani extends StatelessWidget {
  const KullaniciProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profilim', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Kapak ve Profil Fotoğrafı (Facebook tarzı)
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.blue[50],
                  child: Image.network('https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800', fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.white,
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF1D4ED8),
                      child: Text('BB', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            
            // Kullanıcı Bilgileri
            const Text('Burak Büyukelçi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Akdeniz Üniversitesi • Bilgisayar Mühendisliği', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            
            // İstatistikler
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatKutusu('12', 'Katılım'),
                Container(width: 1, height: 30, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 16)),
                _buildStatKutusu('5', 'Takip Edilen'),
              ],
            ),
            
            const Divider(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(alignment: Alignment.centerLeft, child: Text('Paylaştığım Etkinlikler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 16),
            
            // Paylaşılan Etkinlikler (Retweet tarzı)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.repeat, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('Sen bunu paylaştın', style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Kartımızın boyutu patlamasın diye SizedBox içine aldık
                  const SizedBox(
                    height: 260, 
                    width: 200, // Mobilde çok yayılmasın diye genişlik verdik
                    child: EtkinlikKarti(baslik: 'Yapay Zeka Zirvesi', kulup: 'Tech Innovators', fiyat: 'Ücretsiz', tarih: '2024-01-15', resimUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatKutusu(String sayi, String etiket) {
    return Column(
      children: [
        Text(sayi, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(etiket, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}