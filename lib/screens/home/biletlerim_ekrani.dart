import 'package:flutter/material.dart';

class BiletlerimEkrani extends StatelessWidget {
  const BiletlerimEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biletlerim / Rezervasyonlarım')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBiletKarti('Yapay Zeka Zirvesi', '15 Mart 2026 • 14:00', 'Mühendislik Fak. Salon A', 'Bilet #0001', context),
          const SizedBox(height: 16),
          _buildBiletKarti('Bahar Şenliği Konseri', '22 Mart 2026 • 20:00', 'Açık Hava Tiyatrosu', 'Bilet #0084', context),
        ],
      ),
    );
  }

  // QR Kod Dialog'unu açan fonksiyon
  void _qrKoduGoster(BuildContext context, String biletNo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('$biletNo QR Kod', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_2, size: 200, color: Colors.black87), // Dev QR ikonu
            const SizedBox(height: 16),
            const Text('Girişteki görevliye bu ekranı gösterin.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat', style: TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }

  Widget _buildBiletKarti(String baslik, String tarih, String konum, String biletNo, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network('https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=100', width: 60, height: 60, fit: BoxFit.cover),
            ),
            title: Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(children: [const Icon(Icons.calendar_today, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(tarih, style: const TextStyle(fontSize: 12))]),
                const SizedBox(height: 4),
                Row(children: [const Icon(Icons.location_on, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(konum, style: const TextStyle(fontSize: 12))]),
              ],
            ),
          ),
          // Kesik çizgi efekti
          Row(
            children: List.generate(30, (index) => Expanded(child: Container(color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade300, height: 1))),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // YENİ: Tıklanabilir QR Alanı
                InkWell(
                  onTap: () => _qrKoduGoster(context, biletNo),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.qr_code_2, size: 32, color: Color(0xFF1D4ED8)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(biletNo, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('QR Büyüt', style: TextStyle(fontSize: 11, color: Colors.grey[800], fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // YENİ: Etkinlik detayına giden buton
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/event-detail'), 
                  child: const Text('Bileti Gör')
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}