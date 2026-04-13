import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widgets/custom_text_field.dart';

class KullaniciKayitEkrani extends StatefulWidget {
  const KullaniciKayitEkrani({super.key});

  @override
  State<KullaniciKayitEkrani> createState() => _KullaniciKayitEkraniState();
}

class _KullaniciKayitEkraniState extends State<KullaniciKayitEkrani> {
  // --- Controller'lar ---
  final _adController       = TextEditingController();
  final _soyadController    = TextEditingController();
  final _emailController    = TextEditingController();
  final _kullaniciController= TextEditingController(); // userName
  final _sifreController    = TextEditingController();
  final _sifreTekrarController = TextEditingController();

  bool _isLoading = false;
  String? _seciliUniversite;

  Future<void> _kayitOl() async {
    // --- Temel alan kontrolü ---
    if (_adController.text.trim().isEmpty ||
        _soyadController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _kullaniciController.text.trim().isEmpty ||
        _sifreController.text.isEmpty ||
        _sifreTekrarController.text.isEmpty) {
      _goster('Lütfen zorunlu tüm alanları doldurun.');
      return;
    }

    if (_sifreController.text != _sifreTekrarController.text) {
      _goster('Şifreler eşleşmiyor!');
      return;
    }

    if (_sifreController.text.length < 6) {
      _goster('Şifre en az 6 karakter olmalıdır.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('http://localhost:5000/api/Account/register');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName':       _adController.text.trim(),
          'lastName':        _soyadController.text.trim(),
          'email':           _emailController.text.trim(),
          'userName':        _kullaniciController.text.trim(),
          'password':        _sifreController.text,
          'confirmPassword': _sifreTekrarController.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        // Başarılı → giriş ekranına yönlendir
        _goster('Kayıt başarılı! Lütfen giriş yapın.', basarili: true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
      } else {
        // API'den gelen hata mesajını göster
        String mesaj = 'Kayıt başarısız.';
        try {
          final body = jsonDecode(response.body);
          mesaj = body['message'] ?? body['errors']?.toString() ?? mesaj;
        } catch (_) {}
        _goster(mesaj);
      }
    } catch (e) {
      debugPrint('KAYIT HATASI: $e');
      if (mounted) _goster('Sunucuya bağlanılamadı. Backend açık mı?');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goster(String mesaj, {bool basarili = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesaj),
        backgroundColor: basarili ? Colors.green : null,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _emailController.dispose();
    _kullaniciController.dispose();
    _sifreController.dispose();
    _sifreTekrarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Kaydı')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Ad
          CustomTextField(
            controller: _adController,
            hint: 'Ad',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          // Soyad
          CustomTextField(
            controller: _soyadController,
            hint: 'Soyad',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          // Kullanıcı adı
          CustomTextField(
            controller: _kullaniciController,
            hint: 'Kullanıcı Adı',
            icon: Icons.alternate_email,
          ),
          const SizedBox(height: 16),

          // E-posta
          CustomTextField(
            controller: _emailController,
            hint: 'E-posta',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),

          // Üniversite (opsiyonel — API'ye gönderilmiyor henüz)
          DropdownButtonFormField<String>(
            initialValue: _seciliUniversite,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.account_balance_outlined, color: Colors.grey),
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            hint: const Text('Üniversite Seçimi (Opsiyonel)'),
            items: const [
              DropdownMenuItem(value: 'Akdeniz Üniversitesi', child: Text('Akdeniz Üniversitesi')),
              DropdownMenuItem(value: 'Diğer', child: Text('Diğer')),
            ],
            onChanged: (val) => setState(() => _seciliUniversite = val),
          ),
          const SizedBox(height: 16),

          // Şifre
          CustomTextField(
            controller: _sifreController,
            hint: 'Şifre (en az 6 karakter)',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 16),

          // Şifre tekrar
          CustomTextField(
            controller: _sifreTekrarController,
            hint: 'Şifre Tekrar',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 32),

          // Kayıt Ol butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : _kayitOl,
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Kayıt Ol',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
