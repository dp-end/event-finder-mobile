import 'package:flutter/material.dart';
import '../../widgets/etkinlik_karti.dart';

class KulupProfilEkrani extends StatefulWidget {
  const KulupProfilEkrani({super.key});

  @override
  State<KulupProfilEkrani> createState() => _KulupProfilEkraniState();
}

class _KulupProfilEkraniState extends State<KulupProfilEkrani> {
  // Takip Hafızası
  bool _takipEdiliyor = false;
  int _takipciSayisi = 1200; // Başlangıçta 1.2K (1200)

  void _takipTetikle() {
    setState(() {
      _takipEdiliyor = !_takipEdiliyor;
      _takipEdiliyor ? _takipciSayisi++ : _takipciSayisi--;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_takipEdiliyor ? '✅ Kulüp takip ediliyor!' : '❌ Takipten çıkıldı.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _formatSayi(int sayi) {
    if (sayi >= 1000) {
      return '${(sayi / 1000).toStringAsFixed(1)}K'; // 1201 -> 1.2K gibi gösterir
    }
    return sayi.toString();
  }

  @override
  Widget build(BuildContext context) {
    // DÜZELTME BURADA: Tıklanan kulübün adını alıyoruz!
    final kulupVerisi = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {
      'kulupAdi': 'Tech Innovators Club',
    };
    
    String kulupAdi = kulupVerisi['kulupAdi'];
    String harf = kulupAdi.length >= 2 ? kulupAdi.substring(0, 2).toUpperCase() : 'KL';

    return Scaffold(
      appBar: AppBar(title: Text('$kulupAdi Profili')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // KAPAK VE LOGO
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.blue[900],
                  child: Image.network('https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=800', fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: -40,
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue[900],
                      // DİNAMİK HARF
                      child: Text(harf, style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            
            // DİNAMİK KULÜP ADI
            Text(kulupAdi, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Üniversitemizin en aktif teknoloji ve inovasyon topluluğu. Geleceği kodluyoruz, hackathonlar düzenliyoruz!', 
                textAlign: TextAlign.center, 
                style: TextStyle(color: Colors.grey, height: 1.4)
              ),
            ),
            const SizedBox(height: 16),
            
            // DİNAMİK TAKİP BUTONU
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _takipEdiliyor ? Colors.green : const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              ),
              onPressed: _takipTetikle, 
              icon: Icon(_takipEdiliyor ? Icons.check : Icons.person_add, size: 18),
              label: Text(
                _takipEdiliyor ? 'Takip Ediliyor (${_formatSayi(_takipciSayisi)})' : 'Takip Et (${_formatSayi(_takipciSayisi)})', 
                style: const TextStyle(fontWeight: FontWeight.bold)
              )
            ),
            
            const Divider(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              // DİNAMİK LİSTE BAŞLIĞI
              child: Align(alignment: Alignment.centerLeft, child: Text('$kulupAdi Etkinlikleri', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ),
            
            // KULÜBÜN ETKİNLİKLERİ
            GridView.count(
              crossAxisCount: 2, 
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.70,
              children: [
                EtkinlikKarti(baslik: '$kulupAdi Toplantısı', kulup: kulupAdi, fiyat: 'Ücretsiz', tarih: 'Yakında', resimUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400'),
                EtkinlikKarti(baslik: 'Güz Dönemi Etkinliği', kulup: kulupAdi, fiyat: '₺50', tarih: '20-22 Nisan', resimUrl: 'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=400'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}