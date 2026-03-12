import 'package:flutter/material.dart';
import '../../widgets/sol_yan_menu.dart';
import '../../widgets/etkinlik_karti.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  // ARAMA VE FİLTRELEME HAFIZASI
  String _aramaMetni = '';
  String _seciliKategori = 'Tümü';
  
  // Gelişmiş Filtre
  bool _sadeceUcretsiz = false;
  double _maxFiyat = 200; 
  String _seciliZaman = 'Tümü'; 

  final List<Map<String, dynamic>> _tumEtkinlikler = [
    {'baslik': 'Yapay Zeka Zirvesi', 'kulup': 'Tech Innovators', 'kategori': 'Teknoloji', 'fiyat': 0, 'zamanDilimi': 'Bu Hafta', 'tarih': '15 Mart • 14:00', 'resimUrl': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400'},
    {'baslik': 'Bahar Şenliği Konseri', 'kulup': 'Music Society', 'kategori': 'Müzik', 'fiyat': 150, 'zamanDilimi': 'Bu Ay', 'tarih': '28 Mart • 20:00', 'resimUrl': 'https://images.unsplash.com/photo-1540039155732-68ee23e15b51?w=400'},
    {'baslik': 'Doğa Yürüyüşü', 'kulup': 'Outdoor Club', 'kategori': 'Spor', 'fiyat': 0, 'zamanDilimi': 'Bugün', 'tarih': 'Bugün • 09:00', 'resimUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=400'},
    {'baslik': 'Girişimcilik 101', 'kulup': 'Business Club', 'kategori': 'Teknoloji', 'fiyat': 50, 'zamanDilimi': 'Bu Hafta', 'tarih': '18 Mart • 13:00', 'resimUrl': 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=400'},
    {'baslik': 'Basketbol Turnuvası', 'kulup': 'Athletics Assoc.', 'kategori': 'Spor', 'fiyat': 20, 'zamanDilimi': 'Bu Hafta', 'tarih': '19 Mart • 16:00', 'resimUrl': 'https://images.unsplash.com/photo-1519861531473-9200262188bf?w=400'},
  ];

  void _filtreMenusuAc(BuildContext context) {
    bool modalUcretsiz = _sadeceUcretsiz;
    double modalMaxFiyat = _maxFiyat;
    String modalZaman = _seciliZaman;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // GECE MODU UYUMU
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 16),
                  const Text('Gelişmiş Filtre', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Divider(height: 30),
                  
                  const Text('Fiyat Seçenekleri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SwitchListTile(
                    title: const Text('Sadece Ücretsiz Etkinlikler', style: TextStyle(fontWeight: FontWeight.w500)),
                    value: modalUcretsiz,
                    activeColor: const Color(0xFF1D4ED8),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (deger) { setModalState(() { modalUcretsiz = deger; }); },
                  ),
                  
                  if (!modalUcretsiz) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Maksimum Fiyat:'),
                        Text('₺${modalMaxFiyat.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8), fontSize: 16)),
                      ],
                    ),
                    Slider(
                      value: modalMaxFiyat, min: 10, max: 500, divisions: 49,
                      activeColor: const Color(0xFF1D4ED8),
                      onChanged: (yeniDeger) { setModalState(() { modalMaxFiyat = yeniDeger; }); },
                    ),
                  ],
                  const SizedBox(height: 16),
                  
                  const Text('Zaman Dilimi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Tümü', 'Bugün', 'Bu Hafta', 'Bu Ay'].map((tarih) {
                      bool isSelected = modalZaman == tarih;
                      return ChoiceChip(
                        label: Text(tarih),
                        selected: isSelected,
                        selectedColor: const Color(0xFF1D4ED8).withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF1D4ED8) : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87), 
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                        ),
                        onSelected: (secildi) { setModalState(() { modalZaman = tarih; }); },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        setState(() { _sadeceUcretsiz = modalUcretsiz; _maxFiyat = modalMaxFiyat; _seciliZaman = modalZaman; });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filtreler uygulandı!'), duration: Duration(seconds: 1)));
                      },
                      child: const Text('Sonuçları Göster', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtrelenmisListe = _tumEtkinlikler.where((etkinlik) {
      final kategoriUyuyorMu = _seciliKategori == 'Tümü' || etkinlik['kategori'] == _seciliKategori;
      final aramaUyuyorMu = etkinlik['baslik'].toString().toLowerCase().contains(_aramaMetni.toLowerCase()) || etkinlik['kulup'].toString().toLowerCase().contains(_aramaMetni.toLowerCase());
      int fiyat = etkinlik['fiyat'];
      bool fiyatUyuyorMu = _sadeceUcretsiz ? (fiyat == 0) : (fiyat <= _maxFiyat);
      bool zamanUyuyorMu = _seciliZaman == 'Tümü' || etkinlik['zamanDilimi'] == _seciliZaman;
      return kategoriUyuyorMu && aramaUyuyorMu && fiyatUyuyorMu && zamanUyuyorMu;
    }).toList();

    // Gece modu açık mı kontrolü (Arama çubuğu rengi için)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: const SolYanMenu(), // DİKKAT: sol_yan_menu.dart dosyasındaki sabit 'Colors.white' kısımlarını silmelisin.
      appBar: AppBar(
        title: const Text('Event Finder', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.tune), onPressed: () => _filtreMenusuAc(context))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (deger) { setState(() { _aramaMetni = deger; }); },
                decoration: InputDecoration(
                  hintText: 'Etkinlik, kulüp ara...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  // GECE MODU UYUMU: Karanlıksa koyu gri, gündüzse beyaz
                  fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: ['Tümü', 'Spor', 'Teknoloji', 'Müzik', 'Sanat'].map((kategori) {
                  final isSelected = kategori == _seciliKategori;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(kategori), 
                      selected: isSelected, 
                      selectedColor: const Color(0xFF1D4ED8), 
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87), 
                        fontWeight: FontWeight.bold
                      ), 
                      onSelected: (secildiMi) { setState(() { _seciliKategori = kategori; }); },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none,
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12), 
              child: Align(alignment: Alignment.centerLeft, child: Text('Haftanın En Popüler Kulüpleri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildKulupKutusu(context, 'TI', 'Tech Innovators', isDark),
                  _buildKulupKutusu(context, 'MS', 'Music Society', isDark),
                  _buildKulupKutusu(context, 'AA', 'Athletics Assoc.', isDark),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Yaklaşan Etkinlikler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${filtrelenmisListe.length} sonuç', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )
            ),
            
            if (filtrelenmisListe.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text('Aradığınız kritere uygun etkinlik bulunamadı.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), 
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.70,
                ),
                itemCount: filtrelenmisListe.length,
                itemBuilder: (context, index) {
                  final e = filtrelenmisListe[index];
                  String fiyatMetni = e['fiyat'] == 0 ? 'Ücretsiz' : '₺${e['fiyat']}';
                  return EtkinlikKarti(baslik: e['baslik'], kulup: e['kulup'], fiyat: fiyatMetni, tarih: e['tarih'], resimUrl: e['resimUrl']);
                },
              ),
              
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, backgroundColor: const Color(0xFF1D4ED8), child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }

 Widget _buildKulupKutusu(BuildContext context, String harf, String isim, bool isDark) {
    return GestureDetector(
      onTap: () { Navigator.pushNamed(context, '/club-profile', arguments: {'kulupAdi': isim}); },
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        // GECE MODU UYUMU: Kartın arkası ve çerçevesi
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white, 
          borderRadius: BorderRadius.circular(16), 
          border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(backgroundColor: const Color(0xFF1D4ED8).withOpacity(0.1), child: Text(harf, style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Text(isim, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}