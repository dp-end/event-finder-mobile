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
  
  // Gelişmiş Filtre (Sağ Üstteki İkon İçin)
  bool _sadeceUcretsiz = false;
  double _maxFiyat = 200; // Varsayılan en yüksek fiyat sınırı
  String _seciliZaman = 'Tümü'; // 'Tümü', 'Bugün', 'Bu Hafta', 'Bu Ay'

  // GÜNCELLENMİŞ SAHTE VERİTABANIMIZ (Artık sayısal fiyat ve tarih içeriyor)
  final List<Map<String, dynamic>> _tumEtkinlikler = [
    {
      'baslik': 'Yapay Zeka Zirvesi',
      'kulup': 'Tech Innovators',
      'kategori': 'Teknoloji',
      'fiyat': 0, // 0 = Ücretsiz
      'zamanDilimi': 'Bu Hafta',
      'tarih': '15 Mart • 14:00',
      'resimUrl': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400'
    },
    {
      'baslik': 'Bahar Şenliği Konseri',
      'kulup': 'Music Society',
      'kategori': 'Müzik',
      'fiyat': 150,
      'zamanDilimi': 'Bu Ay',
      'tarih': '28 Mart • 20:00',
      'resimUrl': 'https://images.unsplash.com/photo-1540039155732-68ee23e15b51?w=400'
    },
    {
      'baslik': 'Doğa Yürüyüşü',
      'kulup': 'Outdoor Club',
      'kategori': 'Spor',
      'fiyat': 0,
      'zamanDilimi': 'Bugün',
      'tarih': 'Bugün • 09:00',
      'resimUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=400'
    },
    {
      'baslik': 'Girişimcilik 101',
      'kulup': 'Business Club',
      'kategori': 'Teknoloji',
      'fiyat': 50,
      'zamanDilimi': 'Bu Hafta',
      'tarih': '18 Mart • 13:00',
      'resimUrl': 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=400'
    },
    {
      'baslik': 'Basketbol Turnuvası',
      'kulup': 'Athletics Assoc.',
      'kategori': 'Spor',
      'fiyat': 20,
      'zamanDilimi': 'Bu Hafta',
      'tarih': '19 Mart • 16:00',
      'resimUrl': 'https://images.unsplash.com/photo-1519861531473-9200262188bf?w=400'
    },
  ];

  // AŞAĞIDAN AÇILAN FİLTRE MENÜSÜ FONKSİYONU
  void _filtreMenusuAc(BuildContext context) {
    // Menü ilk açıldığında anlık filtreleri geçici değişkenlere alıyoruz
    bool modalUcretsiz = _sadeceUcretsiz;
    double modalMaxFiyat = _maxFiyat;
    String modalZaman = _seciliZaman;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // StatefulBuilder: Alt menünün içindeki değişiklikleri anında (kapatmadan) gösterir
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 16),
                  
                  const Text('Gelişmiş Filtre', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Divider(height: 30),
                  
                  // FİYAT FİLTRESİ
                  const Text('Fiyat Seçenekleri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SwitchListTile(
                    title: const Text('Sadece Ücretsiz Etkinlikler', style: TextStyle(fontWeight: FontWeight.w500)),
                    value: modalUcretsiz,
                    activeColor: const Color(0xFF1D4ED8),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (deger) {
                      setModalState(() { modalUcretsiz = deger; });
                    },
                  ),
                  
                  // Eğer "Sadece Ücretsiz" seçili değilse Fiyat Kaydırıcısını göster
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
                      value: modalMaxFiyat,
                      min: 10,
                      max: 500,
                      divisions: 49,
                      activeColor: const Color(0xFF1D4ED8),
                      onChanged: (yeniDeger) {
                        setModalState(() { modalMaxFiyat = yeniDeger; });
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  
                  // TARİH FİLTRESİ
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
                          color: isSelected ? const Color(0xFF1D4ED8) : Colors.black87, 
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                        ),
                        onSelected: (secildi) {
                          setModalState(() { modalZaman = tarih; });
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // UYGULA BUTONU
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8), 
                        foregroundColor: Colors.white, 
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                      onPressed: () {
                        // Menüdeki seçimleri ANA EKRANA aktar ve sayfayı yenile
                        setState(() {
                          _sadeceUcretsiz = modalUcretsiz;
                          _maxFiyat = modalMaxFiyat;
                          _seciliZaman = modalZaman;
                        });
                        Navigator.pop(context); // Menüyü kapatır
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
    // 🧠 DEV FİLTRELEME MOTORU: Tüm şartları (Arama, Kategori, Fiyat, Tarih) aynı anda kontrol eder.
    final filtrelenmisListe = _tumEtkinlikler.where((etkinlik) {
      // 1. Üst Menü Kategori Filtresi
      final kategoriUyuyorMu = _seciliKategori == 'Tümü' || etkinlik['kategori'] == _seciliKategori;
      
      // 2. Arama Çubuğu Filtresi
      final aramaUyuyorMu = etkinlik['baslik'].toString().toLowerCase().contains(_aramaMetni.toLowerCase()) ||
                            etkinlik['kulup'].toString().toLowerCase().contains(_aramaMetni.toLowerCase());
      
      // 3. Fiyat Filtresi
      int fiyat = etkinlik['fiyat'];
      bool fiyatUyuyorMu = _sadeceUcretsiz ? (fiyat == 0) : (fiyat <= _maxFiyat);
      
      // 4. Zaman Filtresi
      bool zamanUyuyorMu = _seciliZaman == 'Tümü' || etkinlik['zamanDilimi'] == _seciliZaman;

      // Hepsi birden uyuyorsa listeye ekle
      return kategoriUyuyorMu && aramaUyuyorMu && fiyatUyuyorMu && zamanUyuyorMu;
    }).toList();

    return Scaffold(
      drawer: const SolYanMenu(),
      appBar: AppBar(
        title: const Text('CampusHub', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune), 
            onPressed: () => _filtreMenusuAc(context), // Gelişmiş filtre butonumuz
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // DİNAMİK ARAMA ÇUBUĞU
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (deger) {
                  setState(() { _aramaMetni = deger; });
                },
                decoration: InputDecoration(
                  hintText: 'Etkinlik, kulüp ara...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            
            // DİNAMİK KATEGORİLER
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
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold), 
                      onSelected: (secildiMi) {
                        setState(() { _seciliKategori = kategori; });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none,
                    ),
                  );
                }).toList(),
              ),
            ),
            
            // Haftanın Enleri
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
                  _buildKulupKutusu(context, 'TI', 'Tech Innovators'),
                  _buildKulupKutusu(context, 'MS', 'Music Society'),
                  _buildKulupKutusu(context, 'AA', 'Athletics Assoc.'),
                ],
              ),
            ),

            // DİNAMİK ETKİNLİK IZGARASI
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Yaklaşan Etkinlikler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${filtrelenmisListe.length} sonuç', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              )
            ),
            
            // Eğer arama/filtre sonucu boşsa
            if (filtrelenmisListe.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('Aradığınız kritere uygun etkinlik bulunamadı.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), 
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.70, // Kart boy oranı
                ),
                itemCount: filtrelenmisListe.length,
                itemBuilder: (context, index) {
                  final e = filtrelenmisListe[index];
                  // Rakam olan fiyatı String'e çeviriyoruz
                  String fiyatMetni = e['fiyat'] == 0 ? 'Ücretsiz' : '₺${e['fiyat']}';

                  return EtkinlikKarti(
                    baslik: e['baslik'], 
                    kulup: e['kulup'], 
                    fiyat: fiyatMetni, 
                    tarih: e['tarih'], // YENİ: Tarih bilgisi karta gönderiliyor
                    resimUrl: e['resimUrl']
                  );
                },
              ),
              
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, 
        backgroundColor: Colors.teal,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }

 Widget _buildKulupKutusu(BuildContext context, String harf, String isim) {
    return GestureDetector(
      // YENİ EKLENEN KISIM: Kulüp adını sayfaya yollar
      onTap: () {
        Navigator.pushNamed(context, '/club-profile', arguments: {'kulupAdi': isim});
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
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