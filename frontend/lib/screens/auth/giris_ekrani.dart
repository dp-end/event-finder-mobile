import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../widgets/custom_text_field.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Giriş türü: 'student' veya 'club'
  String _seciliTip = 'student';

  Future<void> _girisYap() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('http://localhost:5000/api/Account/authenticate');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'userType': _seciliTip, // backend'e kullanıcı tipini gönder
        }),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body) as Map<String, dynamic>;
        CampusHubApp.userNotifier.value = userData;
        // JWT token'ı kaydet (API isteklerinde kullanmak için)
        CampusHubApp.tokenNotifier.value = userData['jwToken'] as String?;
        // Kullanıcı tipini global state'e kaydet
        CampusHubApp.userTypeNotifier.value = _seciliTip;

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-posta veya şifre hatalı!')),
          );
        }
      }
    } catch (e) {
      debugPrint("BAĞLANTI HATASI DETAYI: $e");

      // Backend bağlantısı yoksa demo modda giriş yap
      if (mounted) {
        CampusHubApp.userNotifier.value = {
          'firstName': _seciliTip == 'club' ? 'Tech Innovators' : 'Demo',
          'lastName': _seciliTip == 'club' ? 'Club' : 'Kullanıcı',
          'email': _emailController.text,
          'userName': _seciliTip == 'club' ? 'techclub' : 'demo_user',
        };
        CampusHubApp.userTypeNotifier.value = _seciliTip;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Image.asset('assets/logo.png', height: 120),

              const SizedBox(height: 12),
              const Text(
                'Event Finder',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 32),

              // KULLANICI TİPİ SEÇİMİ
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _buildTipButonu(
                      etiket: 'Öğrenci Girişi',
                      ikon: Icons.school_outlined,
                      tip: 'student',
                      isDark: isDark,
                    ),
                    _buildTipButonu(
                      etiket: 'Kulüp Girişi',
                      ikon: Icons.groups_outlined,
                      tip: 'club',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              CustomTextField(
                controller: _emailController,
                hint: 'E-posta Adresi',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hint: 'Şifre',
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text(
                    'Şifremi Unuttum?',
                    style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _girisYap,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          _seciliTip == 'club' ? 'Kulüp Girişi Yap' : 'Öğrenci Girişi Yap',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('VEYA', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/signup-select'),
                  child: const Text(
                    'Kayıt Ol',
                    style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipButonu({
    required String etiket,
    required IconData ikon,
    required String tip,
    required bool isDark,
  }) {
    final isSelected = _seciliTip == tip;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _seciliTip = tip),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1D4ED8)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ikon,
                size: 18,
                color: isSelected ? Colors.white : (isDark ? Colors.white60 : Colors.grey[600]),
              ),
              const SizedBox(width: 6),
              Text(
                etiket,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : (isDark ? Colors.white60 : Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
