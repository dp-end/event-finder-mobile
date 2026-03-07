import 'package:flutter/material.dart';

class SolYanMenu extends StatelessWidget {
  const SolYanMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16), 
              child: Align(alignment: Alignment.centerLeft, child: Text('CampusHub', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'serif')))
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
                icon: const Icon(Icons.add), label: const Text('Etkinlik Oluştur', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const Divider(height: 32),
            ListTile(leading: const Icon(Icons.home), title: const Text('Ana Sayfa'), onTap: () => Navigator.pop(context)),
            ListTile(
              leading: const Icon(Icons.notifications), 
              title: const Text('Bildirimler'), 
              trailing: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))), 
              onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/notifications'); }
            ),
            ListTile(leading: const Icon(Icons.confirmation_num), title: const Text('Biletlerim'), onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/my-tickets'); }),
            ListTile(leading: const Icon(Icons.person), title: const Text('Profil'), onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/user-profile'); }),
            ListTile(leading: const Icon(Icons.settings), title: const Text('Ayarlar'), onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/settings'); }),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFF1D4ED8), child: Text('BB', style: TextStyle(color: Colors.white))),
              title: const Text('Burak B.'),
              subtitle: const Text('Bilgisayar Müh. - 2026', style: TextStyle(fontSize: 11)),
              trailing: IconButton(icon: const Icon(Icons.logout, color: Colors.red), onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false)),
            ),
          ],
        ),
      ),
    );
  }
}