import 'package:flutter/material.dart';
import '../main.dart';

class EtkinlikDetayEkrani extends StatefulWidget {
  const EtkinlikDetayEkrani({super.key});

  @override
  State<EtkinlikDetayEkrani> createState() => _EtkinlikDetayEkraniState();
}

class _EtkinlikDetayEkraniState extends State<EtkinlikDetayEkrani> {
  bool _biletAlindiMi = false;
  bool _takipEdiliyorMu = false;
  bool _begenildiMi = false;
  int _begeniSayisi = 24;

  void _begeniTetikle() {
    setState(() {
      _begenildiMi = !_begenildiMi;
      _begenildiMi ? _begeniSayisi++ : _begeniSayisi--;
    });
    ScaffoldMessenger.of(context).clearSnackBars(); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_begenildiMi ? 'Favorilere Eklendi ❤️' : 'Favorilerden Çıkarıldı'), 
        duration: const Duration(seconds: 1)
      )
    );
  }

  void _yorumPenceresiAc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // GECE MODU UYUMU
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, 
            left: 16, right: 16, top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 16),
              const Text('Yorumlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.blue[100], child: const Text('AY', style: TextStyle(color: Colors.blue))),
                title: const Text('Ahmet Yılmaz', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('Kesinlikle orada olacağım, harika etkinlik!', style: TextStyle(fontSize: 13)),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.green[100], child: const Text('ZK', style: TextStyle(color: Colors.green))),
                title: const Text('Zeynep Kaya', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('Biletler tükenmeden aldım :)', style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(height: 8),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Bir yorum yaz...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF1D4ED8)),
                      onPressed: () {
                        Navigator.pop(context); 
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Yorumunuz paylaşıldı!'), duration: Duration(seconds: 2)),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _biletAlOnay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Başarılı!'),
          ],
        ),
        content: const Text('Biletiniz (QR Kod) başarıyla oluşturuldu. İstediğiniz zaman Biletlerim sayfasından görüntüleyebilirsiniz.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _biletAlindiMi = true);
            },
            child: const Text('Burada Kal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              setState(() => _biletAlindiMi = true);
              Navigator.pushNamed(context, '/my-tickets');
            },
            child: const Text('Biletlerime Git'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // GECE MODU KONTROLÜ
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final etkinlikVerisi = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {
      'baslik': 'Bilinmeyen Etkinlik',
      'kulup': 'Bilinmeyen Kulüp',
      'fiyat': 'Ücretsiz',
      'resimUrl': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800',
      'tarih': 'Tarih Belirtilmemiş',
    };

    String kulupBasHarfleri = etkinlikVerisi['kulup'].length >= 2 ? etkinlikVerisi['kulup'].substring(0, 2).toUpperCase() : 'KL';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Gece modunda arkası siyah olur
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(etkinlikVerisi['resimUrl'], fit: BoxFit.cover),
            ),
            // ÜST İKONLAR (Gece modunda beyaz, gündüz siyah ikon)
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDark ? Colors.black54 : Colors.white70,
                child: IconButton(icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black), onPressed: () => Navigator.pop(context)),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: isDark ? Colors.black54 : Colors.white70,
                  child: IconButton(
                    icon: Icon(_begenildiMi ? Icons.favorite : Icons.favorite_border, color: _begenildiMi ? Colors.red : (isDark ? Colors.white : Colors.black)),
                    onPressed: _begeniTetikle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: isDark ? Colors.black54 : Colors.white70,
                  child: IconButton(
                    icon: Icon(Icons.share, color: isDark ? Colors.white : Colors.black),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bağlantı Panoya Kopyalandı!'))),
                  ),
                ),
              ),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: isDark ? Colors.blue.withValues(alpha: 0.2) : Colors.blue[50], borderRadius: BorderRadius.circular(20)),
                    child: const Text('Etkinlik Detayı', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(height: 12),
                  Text(etkinlikVerisi['baslik'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // DİNAMİK Tarih ve Konum (Gece modunda koyu gri arka plan)
                  Row(
                    children: [
                      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[100], borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.calendar_month, color: Color(0xFF1D4ED8))),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(etkinlikVerisi['tarih'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[100], borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.location_on, color: Color(0xFF1D4ED8))),
                      const SizedBox(width: 12),
                      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Mühendislik Fakültesi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('Konferans Salonu A', style: TextStyle(color: Colors.grey, fontSize: 14))]),
                    ],
                  ),
                  
                  const Divider(height: 40),
                  
                  // KULÜP ALANI
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/club-profile', arguments: {'kulupAdi': etkinlikVerisi['kulup']}),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 24, backgroundColor: const Color(0xFF1D4ED8), child: Text(kulupBasHarfleri, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(etkinlikVerisi['kulup'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const Text('Organizatör', style: TextStyle(color: Colors.grey, fontSize: 14))])),
                        GestureDetector(
                          onTap: () => setState(() => _takipEdiliyorMu = !_takipEdiliyorMu),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: _takipEdiliyorMu ? Colors.green.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                            child: Text(_takipEdiliyorMu ? 'Takip Ediliyor' : 'Takip Et', style: TextStyle(color: _takipEdiliyorMu ? Colors.green : const Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // ETKİLEŞİM BUTONLARI ÇUBUĞU
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildEtkilesimButonu(
                          icon: _begenildiMi ? Icons.favorite : Icons.favorite_border,
                          // Gece modunda beyaz, gündüz modunda koyu gri
                          renk: _begenildiMi ? Colors.red : (isDark ? Colors.white70 : Colors.grey[700]!),
                          metin: '$_begeniSayisi Beğeni',
                          isDark: isDark,
                          onTap: _begeniTetikle,
                        ),
                        _buildEtkilesimButonu(
                          icon: Icons.chat_bubble_outline,
                          renk: isDark ? Colors.white70 : Colors.grey[700]!,
                          metin: '2 Yorum',
                          isDark: isDark,
                          onTap: _yorumPenceresiAc,
                        ),
                        _buildEtkilesimButonu(
                          icon: Icons.share,
                          renk: isDark ? Colors.white70 : Colors.grey[700]!,
                          metin: 'Paylaş',
                          isDark: isDark,
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bağlantı kopyalandı!'))),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text('Etkinlik Hakkında', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  // Renk tanımını SİLDİK, artık temadan (Karanlık/Aydınlık) otomatik kendi rengini bulacak
                  const Text('Geleceğin teknolojileri ve yapay zekanın boyutlarını tartışacağımız bu eşsiz etkinliği kaçırmayın!', style: TextStyle(height: 1.5, fontSize: 15)),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      
      // ALTTAKİ BİLET AL BUTONU
      bottomSheet: ValueListenableBuilder<String>(
        valueListenable: CampusHubApp.userTypeNotifier,
        builder: (context, userType, _) {
          final isClub = userType == 'club';

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [BoxShadow(color: isDark ? Colors.black54 : Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(etkinlikVerisi['fiyat'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                    const Text('Kontenjan: 150 kişi', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: isClub
                      // KULÜP HESABI: bilet alamaz, bilgilendirme göster
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade300),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Kulüpler bilet alamaz',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      // ÖĞRENCİ HESABI: normal bilet alma butonu
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _biletAlindiMi ? Colors.green : const Color(0xFF1D4ED8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _biletAlindiMi ? () => Navigator.pushNamed(context, '/my-tickets') : _biletAlOnay,
                          child: Text(
                            _biletAlindiMi ? 'Bileti Gör' : 'Bilet Al / Kayıt Ol',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Etkileşim butonlarını çizen yardımcı fonksiyon
  Widget _buildEtkilesimButonu({required IconData icon, required Color renk, required String metin, required bool isDark, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: renk, size: 22),
            const SizedBox(width: 6),
            // Gece modunda yazılar parlasın, gündüz siyah dursun
            Text(metin, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[800], fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}