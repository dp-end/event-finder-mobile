import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../widgets/sol_yan_menu.dart';
import '../../widgets/etkinlik_karti.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String _aramaMetni = '';
  String _seciliKategori = 'Tümü';
  bool _sadeceUcretsiz = false;
  double _maxFiyat = 200;
  String _seciliZaman = 'Tümü';

  // API'den gelen etkinlik listesi
  List<Map<String, dynamic>> _etkinlikler = [];
  bool _yukleniyor = true;
  String? _hata;

  @override
  void initState() {
    super.initState();
    _etkinlikleriYukle();
  }

  Future<void> _etkinlikleriYukle() async {
    setState(() {
      _yukleniyor = true;
      _hata = null;
    });

    try {
      final token = CampusHubApp.tokenNotifier.value;

      // Filtre parametreleri
      final params = <String, String>{};
      if (_aramaMetni.isNotEmpty) params['query'] = _aramaMetni;
      if (_seciliKategori != 'Tümü') params['category'] = _seciliKategori;
      if (_sadeceUcretsiz) params['freeOnly'] = 'true';
      if (!_sadeceUcretsiz && _maxFiyat < 500) params['maxPrice'] = _maxFiyat.toStringAsFixed(0);
      if (_seciliZaman != 'Tümü') params['timePeriod'] = _seciliZaman;

      final url = Uri.parse('http://localhost:5000/api/Events').replace(queryParameters: params.isEmpty ? null : params);

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final liste = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _etkinlikler = liste.cast<Map<String, dynamic>>();
          _yukleniyor = false;
        });
      } else {
        setState(() {
          _hata = 'Etkinlikler yüklenemedi (${response.statusCode})';
          _yukleniyor = false;
        });
      }
    } catch (e) {
      setState(() {
        _hata = 'Sunucuya bağlanılamadı';
        _yukleniyor = false;
        // Bağlantı yoksa boş liste göster
        _etkinlikler = [];
      });
    }
  }

  void _filtreMenusuAc(BuildContext context) {
    bool modalUcretsiz = _sadeceUcretsiz;
    double modalMaxFiyat = _maxFiyat;
    String modalZaman = _seciliZaman;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    activeThumbColor: const Color(0xFF1D4ED8),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (d) => setModalState(() => modalUcretsiz = d),
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
                      onChanged: (v) => setModalState(() => modalMaxFiyat = v),
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
                        selectedColor: const Color(0xFF1D4ED8).withValues(alpha: 0.1),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF1D4ED8) : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (_) => setModalState(() => modalZaman = tarih),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        setState(() {
                          _sadeceUcretsiz = modalUcretsiz;
                          _maxFiyat = modalMaxFiyat;
                          _seciliZaman = modalZaman;
                        });
                        Navigator.pop(context);
                        _etkinlikleriYukle(); // Filtreyle yeniden yükle
                      },
                      child: const Text('Sonuçları Göster', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Arama metnini client-side da filtrele (anlık arama için)
    final gosterilenListe = _aramaMetni.isEmpty
        ? _etkinlikler
        : _etkinlikler.where((e) {
            final baslik = (e['title'] ?? '').toString().toLowerCase();
            final kulup  = (e['clubName'] ?? '').toString().toLowerCase();
            return baslik.contains(_aramaMetni.toLowerCase()) || kulup.contains(_aramaMetni.toLowerCase());
          }).toList();

    return Scaffold(
      drawer: const SolYanMenu(),
      appBar: AppBar(
        title: const Text('Event Finder', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.tune), onPressed: () => _filtreMenusuAc(context)),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _etkinlikleriYukle),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _etkinlikleriYukle,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // ARAMA ÇUBUĞU
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (d) => setState(() => _aramaMetni = d),
                  decoration: InputDecoration(
                    hintText: 'Etkinlik, kulüp ara...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),

              // KATEGORİ FİLTRESİ
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: ['Tümü', 'Spor', 'Teknoloji', 'Müzik', 'Sanat', 'Kariyer'].map((kategori) {
                    final isSelected = kategori == _seciliKategori;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(kategori),
                        selected: isSelected,
                        selectedColor: const Color(0xFF1D4ED8),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (_) {
                          setState(() => _seciliKategori = kategori);
                          _etkinlikleriYukle();
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide.none,
                      ),
                    );
                  }).toList(),
                ),
              ),

              // POPÜLER KULÜPLER
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Align(alignment: Alignment.centerLeft, child: Text('Haftanın En Popüler Kulüpleri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
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

              // ETKİNLİKLER BAŞLIĞI
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Yaklaşan Etkinlikler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if (!_yukleniyor)
                      Text('${gosterilenListe.length} sonuç', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),

              // İÇERİK: yükleniyor / hata / liste
              if (_yukleniyor)
                const Padding(
                  padding: EdgeInsets.all(48),
                  child: CircularProgressIndicator(color: Color(0xFF1D4ED8)),
                )
              else if (_hata != null)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.wifi_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(_hata!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _etkinlikleriYukle,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tekrar Dene'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                )
              else if (gosterilenListe.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
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
                  itemCount: gosterilenListe.length,
                  itemBuilder: (context, index) {
                    final e = gosterilenListe[index];
                    final fiyat = (e['price'] as num?) ?? 0;
                    final fiyatMetni = fiyat == 0 ? 'Ücretsiz' : '₺${fiyat.toStringAsFixed(0)}';
                    final tarih = e['date'] != null
                        ? _formatTarih(e['date'].toString())
                        : 'Tarih belirtilmemiş';
                    return EtkinlikKarti(
                      baslik: e['title'] ?? '',
                      kulup:  e['clubName'] ?? 'Bireysel Etkinlik',
                      fiyat:  fiyatMetni,
                      tarih:  tarih,
                      resimUrl: e['imageUrl'] ?? 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400',
                      etkinlikId: e['id']?.toString(),
                    );
                  },
                ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Etkinlik oluşturulursa true döner, listeyi yenile
          final sonuc = await Navigator.pushNamed(context, '/create-event');
          if (sonuc == true) _etkinlikleriYukle();
        },
        backgroundColor: const Color(0xFF1D4ED8),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatTarih(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      return '${dt.day} ${_ayAdi(dt.month)} • ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoString;
    }
  }

  String _ayAdi(int ay) {
    const aylar = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    return aylar[ay - 1];
  }

  Widget _buildKulupKutusu(BuildContext context, String harf, String isim, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/club-profile', arguments: {'kulupAdi': isim}),
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF1D4ED8).withValues(alpha: 0.1),
              child: Text(harf, style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Text(isim, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
