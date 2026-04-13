import 'package:flutter/material.dart';

class KulupKesfetEkrani extends StatefulWidget {
  const KulupKesfetEkrani({super.key});

  @override
  State<KulupKesfetEkrani> createState() => _KulupKesfetEkraniState();
}

class _KulupKesfetEkraniState extends State<KulupKesfetEkrani> {
  String _aramaMetni = '';
  String _seciliKategori = 'Tümü';

  // Takip edilen kulüpler seti
  final Set<String> _takipEdilenler = {};

  final List<Map<String, dynamic>> _kulupListesi = [
    {
      'id': '1',
      'ad': 'Tech Innovators',
      'kisaltma': 'TI',
      'kategori': 'Teknoloji',
      'aciklama': 'Yapay zeka ve yazılım geliştirme odaklı kulüp.',
      'takipci': 1240,
      'etkinlikSayisi': 8,
      'renk': Colors.blue,
    },
    {
      'id': '2',
      'ad': 'Music Society',
      'kisaltma': 'MS',
      'kategori': 'Sanat',
      'aciklama': 'Müzik severler için konser ve workshop etkinlikleri.',
      'takipci': 890,
      'etkinlikSayisi': 5,
      'renk': Colors.purple,
    },
    {
      'id': '3',
      'ad': 'Athletics Association',
      'kisaltma': 'AA',
      'kategori': 'Spor',
      'aciklama': 'Basketbol, futbol ve koşu turnuvaları düzenleriz.',
      'takipci': 2100,
      'etkinlikSayisi': 12,
      'renk': Colors.orange,
    },
    {
      'id': '4',
      'ad': 'Business Club',
      'kisaltma': 'BC',
      'kategori': 'İş Dünyası',
      'aciklama': 'Girişimcilik ve kariyer gelişimi seminerleri.',
      'takipci': 670,
      'etkinlikSayisi': 6,
      'renk': Colors.green,
    },
    {
      'id': '5',
      'ad': 'Photography Club',
      'kisaltma': 'PC',
      'kategori': 'Sanat',
      'aciklama': 'Fotoğraf çekimi ve sergi etkinlikleri.',
      'takipci': 450,
      'etkinlikSayisi': 3,
      'renk': Colors.red,
    },
    {
      'id': '6',
      'ad': 'Outdoor Club',
      'kisaltma': 'OC',
      'kategori': 'Spor',
      'aciklama': 'Doğa yürüyüşleri ve kamp etkinlikleri.',
      'takipci': 780,
      'etkinlikSayisi': 9,
      'renk': Colors.teal,
    },
  ];

  List<Map<String, dynamic>> get _filtrelenmisListe {
    return _kulupListesi.where((kulup) {
      final kategoriUyuyor = _seciliKategori == 'Tümü' || kulup['kategori'] == _seciliKategori;
      final aramaUyuyor = kulup['ad'].toString().toLowerCase().contains(_aramaMetni.toLowerCase()) ||
          kulup['aciklama'].toString().toLowerCase().contains(_aramaMetni.toLowerCase());
      return kategoriUyuyor && aramaUyuyor;
    }).toList();
  }

  String _formatSayi(int sayi) {
    if (sayi >= 1000) {
      return '${(sayi / 1000).toStringAsFixed(1)}K';
    }
    return sayi.toString();
  }

  void _takipTetikle(String kulupId, String kulupAdi) {
    setState(() {
      if (_takipEdilenler.contains(kulupId)) {
        _takipEdilenler.remove(kulupId);
      } else {
        _takipEdilenler.add(kulupId);
      }
    });
    final takipEdiliyor = _takipEdilenler.contains(kulupId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(takipEdiliyor ? '$kulupAdi takip ediliyor.' : '$kulupAdi takipten çıkıldı.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kategoriler = ['Tümü', 'Teknoloji', 'Sanat', 'Spor', 'İş Dünyası'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kulüpleri Keşfet', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ARAMA ALANI
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (deger) => setState(() => _aramaMetni = deger),
              decoration: InputDecoration(
                hintText: 'Kulüp ara...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // KATEGORİ FİLTRESİ
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: kategoriler.map((kategori) {
                final isSelected = kategori == _seciliKategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(kategori),
                    selected: isSelected,
                    selectedColor: const Color(0xFF1D4ED8),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    onSelected: (_) => setState(() => _seciliKategori = kategori),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // KULÜP LİSTESİ
          Expanded(
            child: _filtrelenmisListe.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'Arama kriterine uygun kulüp bulunamadı.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filtrelenmisListe.length,
                    itemBuilder: (context, index) {
                      final kulup = _filtrelenmisListe[index];
                      final takipEdiliyor = _takipEdilenler.contains(kulup['id']);
                      final Color renk = kulup['renk'] as Color;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/club-profile',
                            arguments: {'kulupAdi': kulup['ad']},
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // KULÜP AVATARI
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: renk.withValues(alpha: 0.15),
                                  child: Text(
                                    kulup['kisaltma'],
                                    style: TextStyle(
                                      color: renk,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // KULÜP BİLGİLERİ
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              kulup['ad'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: renk.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              kulup['kategori'],
                                              style: TextStyle(
                                                color: renk,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        kulup['aciklama'],
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.people_outline, size: 14, color: Colors.grey[500]),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${_formatSayi(kulup['takipci'] + (takipEdiliyor ? 1 : 0))} takipçi',
                                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(Icons.event_outlined, size: 14, color: Colors.grey[500]),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${kulup['etkinlikSayisi']} etkinlik',
                                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // TAKİP BUTONU
                                GestureDetector(
                                  onTap: () => _takipTetikle(kulup['id'], kulup['ad']),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: takipEdiliyor
                                          ? Colors.green.withValues(alpha: 0.15)
                                          : const Color(0xFF1D4ED8).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: takipEdiliyor ? Colors.green : const Color(0xFF1D4ED8),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      takipEdiliyor ? 'Takipte' : 'Takip Et',
                                      style: TextStyle(
                                        color: takipEdiliyor ? Colors.green : const Color(0xFF1D4ED8),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
