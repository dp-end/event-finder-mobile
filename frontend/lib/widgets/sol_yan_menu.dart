import 'package:flutter/material.dart';
import '../main.dart';

class SolYanMenu extends StatelessWidget {
  const SolYanMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: CampusHubApp.langNotifier,
      builder: (context, dil, _) {
        return ValueListenableBuilder<String>(
          valueListenable: CampusHubApp.userTypeNotifier,
          builder: (context, userType, _) {
            return ValueListenableBuilder<Map<String, dynamic>?>(
              valueListenable: CampusHubApp.userNotifier,
              builder: (context, user, _) {
                final isEng = dil == 'English';
                final isClub = userType == 'club';

                // Kullanıcı bilgileri
                final firstName = user?['firstName'] as String? ?? '';
                final lastName = user?['lastName'] as String? ?? '';
                final email = user?['email'] as String? ?? '';
                final fullName = '$firstName $lastName'.trim();
                final initials = _initials(firstName, lastName);

                return Drawer(
                  child: SafeArea(
                    child: Column(
                      children: [
                        // BAŞLIK
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Event Finder',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'serif'),
                            ),
                          ),
                        ),

                        // ÜNİVERSİTE SEÇİCİ
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonFormField<String>(
                            initialValue: '1',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            items: const [
                              DropdownMenuItem(value: '1', child: Text('Akdeniz Üniversitesi')),
                            ],
                            onChanged: (val) {},
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ETKİNLİK OLUŞTUR (hem öğrenci hem kulüp görebilir)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1D4ED8),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/create-event');
                            },
                            icon: const Icon(Icons.add),
                            label: Text(
                              isEng ? 'Create Event' : 'Etkinlik Oluştur',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        // KULÜP: Diğer kulüpleri keşfet butonu
                        if (isClub) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: const BorderSide(color: Color(0xFF1D4ED8)),
                                foregroundColor: const Color(0xFF1D4ED8),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/club-discover');
                              },
                              icon: const Icon(Icons.explore_outlined, size: 20),
                              label: Text(
                                isEng ? 'Discover Clubs' : 'Kulüpleri Keşfet',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],

                        const Divider(height: 32),

                        // MENÜ LİSTESİ
                        ListTile(
                          leading: const Icon(Icons.home),
                          title: Text(isEng ? 'Home' : 'Ana Sayfa'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(isEng ? 'Notifications' : 'Bildirimler'),
                          trailing: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/notifications');
                          },
                        ),

                        // BİLETLERİM: sadece öğrenciler görebilir
                        if (!isClub)
                          ListTile(
                            leading: const Icon(Icons.confirmation_num),
                            title: Text(isEng ? 'My Tickets' : 'Biletlerim'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/my-tickets');
                            },
                          ),

                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(isEng ? 'Profile' : 'Profil'),
                          onTap: () {
                            Navigator.pop(context);
                            if (isClub) {
                              Navigator.pushNamed(
                                context,
                                '/club-profile',
                                arguments: {'kulupAdi': fullName.isNotEmpty ? fullName : 'Kulübüm'},
                              );
                            } else {
                              Navigator.pushNamed(context, '/user-profile');
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: Text(isEng ? 'Settings' : 'Ayarlar'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/settings');
                          },
                        ),

                        const Spacer(),
                        const Divider(),

                        // KULLANICI BİLGİ ALANI (dinamik)
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isClub ? Colors.orange : const Color(0xFF1D4ED8),
                            child: Text(
                              initials,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            fullName.isNotEmpty ? fullName : (isEng ? 'User' : 'Kullanıcı'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            isClub
                                ? (isEng ? 'Club Account' : 'Kulüp Hesabı')
                                : (email.isNotEmpty ? email : (isEng ? 'Student' : 'Öğrenci')),
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.logout, color: Colors.red),
                            onPressed: () {
                              CampusHubApp.userNotifier.value = null;
                              CampusHubApp.userTypeNotifier.value = 'student';
                              CampusHubApp.tokenNotifier.value = null;
                              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _initials(String first, String last) {
    final f = first.isNotEmpty ? first[0].toUpperCase() : '';
    final l = last.isNotEmpty ? last[0].toUpperCase() : '';
    final result = '$f$l';
    return result.isNotEmpty ? result : '?';
  }
}
