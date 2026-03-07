import 'package:flutter/material.dart';

class EtkinlikOlusturEkrani extends StatefulWidget {
  const EtkinlikOlusturEkrani({super.key});

  @override
  State<EtkinlikOlusturEkrani> createState() => _EtkinlikOlusturEkraniState();
}

class _EtkinlikOlusturEkraniState extends State<EtkinlikOlusturEkrani> {
  // Form kontrolcüsü ve Yükleme durumu
  final _formKey = GlobalKey<FormState>();
  bool _yukleniyor = false;
  String _seciliKategori = 'Teknoloji';

  void _etkinlikKaydet() async {
    // Eğer zorunlu alanlar doldurulduysa
    if (_formKey.currentState!.validate()) {
      setState(() => _yukleniyor = true); // Yükleniyor animasyonunu başlat
      
      // Veritabanına kaydediyormuş gibi 2 saniye bekle
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      setState(() => _yukleniyor = false); // Yükleniyor animasyonunu bitir
      
      // Başarı mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Etkinlik başarıyla oluşturuldu!'), 
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // İşlem bitince bir önceki sayfaya (Ana Sayfaya) dön
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Yeni Etkinlik Oluştur', style: TextStyle(fontWeight: FontWeight.bold))),
      body: _yukleniyor 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF1D4ED8)),
                SizedBox(height: 16),
                Text('Etkinlik yayınlanıyor...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BAŞLIK
                  const Text('Etkinlik Başlığı', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Örn: Yapay Zeka Zirvesi', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    validator: (deger) => deger == null || deger.isEmpty ? 'Lütfen bir başlık girin' : null,
                  ),
                  const SizedBox(height: 20),
                  
                  // KATEGORİ
                  const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _seciliKategori,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    items: ['Teknoloji', 'Spor', 'Sanat', 'Müzik'].map((kategori) {
                      return DropdownMenuItem(value: kategori, child: Text(kategori));
                    }).toList(),
                    onChanged: (yeniKategori) {
                      setState(() => _seciliKategori = yeniKategori!);
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // TARİH VE SAAT (Şimdilik metin kutusu, backend'de DatePicker yaparız)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tarih', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'GG/AA/YYYY', prefixIcon: const Icon(Icons.calendar_today, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                              validator: (deger) => deger!.isEmpty ? 'Boş bırakılamaz' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Saat', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(hintText: '00:00', prefixIcon: const Icon(Icons.access_time, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                              validator: (deger) => deger!.isEmpty ? 'Boş bırakılamaz' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // KONUM VE AÇIKLAMA
                  const Text('Konum', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Örn: Mühendislik Fak. Konferans Salonu', prefixIcon: const Icon(Icons.location_on, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    validator: (deger) => deger!.isEmpty ? 'Lütfen bir konum belirtin' : null,
                  ),
                  const SizedBox(height: 20),

                  const Text('Açıklama', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 4,
                    decoration: InputDecoration(hintText: 'Etkinlik hakkında detaylı bilgi verin...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    validator: (deger) => deger!.isEmpty ? 'Lütfen bir açıklama girin' : null,
                  ),
                  const SizedBox(height: 40),
                  
                  // KAYDET BUTONU
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                      onPressed: _etkinlikKaydet,
                      child: const Text('Etkinliği Yayınla', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
    );
  }
}