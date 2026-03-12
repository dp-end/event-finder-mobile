import 'package:flutter/material.dart';
import '../../main.dart'; // Dil hafızası (CampusHubApp) için gerekli

class SolYanMenu extends StatelessWidget {
  const SolYanMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Menünün dil değişiminde anında güncellenmesi için ValueListenableBuilder kullanıyoruz
    return ValueListenableBuilder<String>(
      valueListenable: CampusHubApp.langNotifier,
      builder: (context, dil, child) {
        // Seçili dilin İngilizce olup olmadığını kontrol et
        final isEng = dil == 'English';

        return Drawer(
          // backgroundColor: Colors.white, <-- HAYALET EKRANIN SEBEBİ BUYDU, SİLDİK! Artık temadan uyumlu renk alacak.
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16), 
                  child: Align(
                    alignment: Alignment.centerLeft, 
                    // Eski adı sildik, uygulamamızın yeni adını koyduk
                    child: Text('Event Finder', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'serif'))
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    value: '1',
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
                    items: const [DropdownMenuItem(value: '1', child: Text('Akdeniz Üniversitesi'))],
                    onChanged: (val) {},
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () { 
                      Navigator.pop(context); // Menüyü kapat
                      Navigator.pushNamed(context, '/create-event'); // Etkinlik oluşturmaya git
                    },
                    icon: const Icon(Icons.add), 
                    // Dil seçeneğine göre buton metni
                    label: Text(isEng ? 'Create Event' : 'Etkinlik Oluştur', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const Divider(height: 32),
                
                // MENÜ LİSTESİ (İngilizce / Türkçe Destekli)
                ListTile(
                  leading: const Icon(Icons.home), 
                  title: Text(isEng ? 'Home' : 'Ana Sayfa'), 
                  onTap: () => Navigator.pop(context)
                ),
                ListTile(
                  leading: const Icon(Icons.notifications), 
                  title: Text(isEng ? 'Notifications' : 'Bildirimler'), 
                  trailing: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))), 
                  onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/notifications'); }
                ),
                ListTile(
                  leading: const Icon(Icons.confirmation_num), 
                  title: Text(isEng ? 'My Tickets' : 'Biletlerim'), 
                  onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/my-tickets'); }
                ),
                ListTile(
                  leading: const Icon(Icons.person), 
                  title: Text(isEng ? 'Profile' : 'Profil'), 
                  onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/user-profile'); }
                ),
                ListTile(
                  leading: const Icon(Icons.settings), 
                  title: Text(isEng ? 'Settings' : 'Ayarlar'), 
                  onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/settings'); }
                ),
                
                const Spacer(),
                const Divider(),
                // KULLANICI BİLGİ ALANI
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Color(0xFF1D4ED8), child: Text('BB', style: TextStyle(color: Colors.white))),
                  title: const Text('Burak B.'),
                  subtitle: Text(isEng ? 'Computer Eng. - 2026' : 'Bilgisayar Müh. - 2026', style: const TextStyle(fontSize: 11)),
                  trailing: IconButton(icon: const Icon(Icons.logout, color: Colors.red), onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false)),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}