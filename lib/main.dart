import 'package:flutter/material.dart';
import 'core/theme.dart';
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


void main() {
  runApp(const CampusHubApp());
}

class CampusHubApp extends StatelessWidget {
  const CampusHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusHub',
      theme: AppTheme.lightTheme,
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
      },
    );
  }
}