import 'package:flutter/material.dart';

class EtkinlikKarti extends StatefulWidget {
  final String baslik;
  final String kulup;
  final String fiyat;
  final String resimUrl;
  final String tarih;
  final String? etkinlikId; // API'den gelen UUID (opsiyonel, detay sayfasında kullanılır)

  const EtkinlikKarti({
    super.key,
    required this.baslik,
    required this.kulup,
    required this.fiyat,
    required this.resimUrl,
    required this.tarih,
    this.etkinlikId,
  });

  @override
  State<EtkinlikKarti> createState() => _EtkinlikKartiState();
}

class _EtkinlikKartiState extends State<EtkinlikKarti> {
  // Beğeni hafızası
  bool _begenildiMi = false;
  int _begeniSayisi = 24;

  void _begeniTetikle() {
    setState(() {
      _begenildiMi = !_begenildiMi;
      _begenildiMi ? _begeniSayisi++ : _begeniSayisi--;
    });
  }

  // Yorum penceresini açan fonksiyon
  void _yorumPenceresiAc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, 
            left: 16, right: 16, top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // DÜZELTME BURADA: Tıklanınca kartın verilerini detay sayfasına yollar!
      onTap: () => Navigator.pushNamed(context, '/event-detail', arguments: {
        'baslik': widget.baslik,
        'kulup': widget.kulup,
        'fiyat': widget.fiyat,
        'resimUrl': widget.resimUrl,
        'tarih': widget.tarih,
        if (widget.etkinlikId != null) 'etkinlikId': widget.etkinlikId,
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor, 
          borderRadius: BorderRadius.circular(16), 
          border: Border.all(color: Colors.grey.shade200)
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(widget.resimUrl, height: 110, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 8, left: 8, 
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                    decoration: BoxDecoration(color: widget.fiyat == 'Ücretsiz' ? Colors.green : const Color(0xFF1D4ED8), borderRadius: BorderRadius.circular(8)), 
                    child: Text(widget.fiyat, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
                  )
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      // DÜZELTME BURADA: Kulübe tıklanınca adını profiline yollar!
                      onTap: () => Navigator.pushNamed(context, '/club-profile', arguments: {'kulupAdi': widget.kulup}),
                      child: Text(widget.kulup, style: TextStyle(fontSize: 10, color: Colors.blue[700], fontWeight: FontWeight.bold), maxLines: 1),
                    ),
                    const SizedBox(height: 4),
                    Text(widget.baslik, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.1), maxLines: 2, overflow: TextOverflow.ellipsis),
                    
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(widget.tarih, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                      ],
                    ),

                    const Spacer(),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _begeniTetikle,
                          child: Row(
                            children: [
                              Icon(_begenildiMi ? Icons.favorite : Icons.favorite_border, size: 16, color: _begenildiMi ? Colors.red : Colors.grey), 
                              const SizedBox(width: 4), 
                              Text('$_begeniSayisi', style: TextStyle(fontSize: 11, color: _begenildiMi ? Colors.red : Colors.grey[700]))
                            ]
                          ),
                        ),
                        GestureDetector(
                          onTap: _yorumPenceresiAc,
                          child: Row(
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey[700]), 
                              const SizedBox(width: 4), 
                              Text('2', style: TextStyle(fontSize: 11, color: Colors.grey[700]))
                            ]
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bağlantı kopyalandı!')));
                          },
                          child: Icon(Icons.share, size: 16, color: Colors.grey[700])
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}