import 'package:flutter/material.dart';
import 'screens/auth/giris_ekrani.dart';
import 'screens/auth/kayit_secim_ekrani.dart';
import 'screens/auth/kullanici_kayit_ekrani.dart';
import 'screens/auth/kulup_kayit_ekrani.dart';
import 'screens/auth/sifremi_unuttum_ekrani.dart';
import 'screens/home/ana_sayfa.dart';
import 'screens/etkinlik_olustur_ekrani.dart';
import 'screens/etkinlik_detay_ekrani.dart';
import 'screens/profile/kullanici_profil_ekrani.dart';
import 'screens/profile/kulup_profil_ekrani.dart';
import 'screens/home/biletlerim_ekrani.dart';
import 'screens/home/bildirimler_ekrani.dart';
import 'screens/profile/ayarlar_ekrani.dart';
import 'screens/kulup_kesfet_ekrani.dart';

void main() {
  runApp(const CampusHubApp());
}

class CampusHubApp extends StatelessWidget {
  const CampusHubApp({super.key});

  // TEMA HAFIZASI
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  // DİL HAFIZASI
  static final ValueNotifier<String> langNotifier = ValueNotifier('Türkçe');
  // GİRİŞ YAPAN KULLANICI BİLGİSİ (null = giriş yapılmamış)
  static final ValueNotifier<Map<String, dynamic>?> userNotifier = ValueNotifier(null);
  // KULLANICI TİPİ: 'student' = öğrenci, 'club' = kulüp
  static final ValueNotifier<String> userTypeNotifier = ValueNotifier('student');
  // JWT TOKEN (API isteklerinde Authorization header için)
  static final ValueNotifier<String?> tokenNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    // İki hafızayı aynı anda dinlemek için ListenableBuilder kullanıyoruz
    return ListenableBuilder(
      listenable: Listenable.merge([themeNotifier, langNotifier]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Event Finder',
          debugShowCheckedModeBanner: false,
          
          themeMode: themeNotifier.value, // Temayı buradan alıyor
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF1D4ED8),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF1D4ED8),
            scaffoldBackgroundColor: const Color(0xFF121212),
            drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1E1E1E)), // GECE MENÜ RENGİ (Hayalet sorununun çözümü!)
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF121212), foregroundColor: Colors.white),
          ),
          
          // ROTALAR (SAYFALAR)
          initialRoute: '/',
          routes: {
            '/': (context) => const GirisEkrani(),
            '/signup-select': (context) => const KayitSecimEkrani(),
            '/user-signup': (context) => const KullaniciKayitEkrani(),
            '/club-signup': (context) => const KulupKayitEkrani(),
            '/forgot-password': (context) => const SifremiUnuttumEkrani(),
            '/home': (context) => const AnaSayfa(),
            '/create-event': (context) => const EtkinlikOlusturEkrani(),
            '/event-detail': (context) => const EtkinlikDetayEkrani(),
            '/my-tickets': (context) => const BiletlerimEkrani(),
            '/user-profile': (context) => const KullaniciProfilEkrani(),
            '/club-profile': (context) => const KulupProfilEkrani(),
            '/notifications': (context) => const BildirimlerEkrani(),
            '/settings': (context) => const AyarlarEkrani(),
            '/club-discover': (context) => const KulupKesfetEkrani(),
          },
        );
      },
    );
  }
}