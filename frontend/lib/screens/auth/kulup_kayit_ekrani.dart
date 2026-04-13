import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widgets/custom_text_field.dart';

class KulupKayitEkrani extends StatefulWidget {
  const KulupKayitEkrani({super.key});

  @override
  State<KulupKayitEkrani> createState() => _KulupKayitEkraniState();
}

class _KulupKayitEkraniState extends State<KulupKayitEkrani> {
  final _kulupAdiController      = TextEditingController();
  final _emailController         = TextEditingController();
  final _kullaniciAdiController  = TextEditingController();
  final _danismanController      = TextEditingController();
  final _telefonController       = TextEditingController();
  final _referansController      = TextEditingController();
  final _sifreController         = TextEditingController();
  final _sifreTekrarController   = TextEditingController();

  String? _seciliUniversite;
  bool _isLoading = false;

  @override
  void dispose() {
    _kulupAdiController.dispose();
    _emailController.dispose();
    _kullaniciAdiController.dispose();
    _danismanController.dispose();
    _telefonController.dispose();
    _referansController.dispose();
    _sifreController.dispose();
    _sifreTekrarController.dispose();
    super.dispose();
  }

  Future<void> _kayitOl() async {
    // Alan doğrulama
    if (_kulupAdiController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _kullaniciAdiController.text.trim().isEmpty ||
        _sifreController.text.isEmpty ||
        _sifreTekrarController.text.isEmpty) {
      _goster('Lütfen zorunlu alanları doldurun (Kulüp adı, e-posta, kullanıcı adı, şifre).');
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
          // Backend RegisterRequest alanları
          'firstName':       _kulupAdiController.text.trim(), // FirstName = ClubName (backend handle eder)
          'lastName':        '',
          'email':           _emailController.text.trim(),
          'userName':        _kullaniciAdiController.text.trim(),
          'password':        _sifreController.text,
          'confirmPassword': _sifreTekrarController.text,
          // Kulüp özel alanlar
          'userType':        'club',
          'clubName':        _kulupAdiController.text.trim(),
          'advisorName':     _danismanController.text.trim(),
          'phoneNumber':     _telefonController.text.trim(),
          'referenceNumber': _referansController.text.trim(),
          'university':      _seciliUniversite ?? '',
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        _goster('Kulüp kaydı başarılı! Kulüp girişi yapabilirsiniz.', basarili: true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
      } else {
        String mesaj = 'Kayıt başarısız.';
        try {
          final body = jsonDecode(response.body);
          mesaj = body['message'] ?? body['errors']?.toString() ?? mesaj;
        } catch (_) {}
        _goster(mesaj);
      }
    } catch (e) {
      debugPrint('KULÜP KAYIT HATASI: $e');
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Kulüp Kaydı')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Kulüp Adı
          CustomTextField(
            controller: _kulupAdiController,
            hint: 'Kulüp Adı *',
            icon: Icons.groups_outlined,
          ),
          const SizedBox(height: 16),

          // Kullanıcı Adı
          CustomTextField(
            controller: _kullaniciAdiController,
            hint: 'Kullanıcı Adı * (giriş için)',
            icon: Icons.alternate_email,
          ),
          const SizedBox(height: 16),

          // Kulüp E-postası
          CustomTextField(
            controller: _emailController,
            hint: 'Kulüp E-postası *',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),

          // Danışman Hoca
          CustomTextField(
            controller: _danismanController,
            hint: 'Danışman Hoca (opsiyonel)',
            icon: Icons.school_outlined,
          ),
          const SizedBox(height: 16),

          // Kulüp Telefonu
          CustomTextField(
            controller: _telefonController,
            hint: 'Kulüp Telefonu (opsiyonel)',
            icon: Icons.phone_outlined,
          ),
          const SizedBox(height: 16),

          // Referans Numarası
          CustomTextField(
            controller: _referansController,
            hint: 'Referans Numarası (opsiyonel)',
            icon: Icons.tag,
          ),
          const SizedBox(height: 16),

          // Üniversite Seçimi
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
            hint: const Text('Üniversite Seçimi'),
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
            hint: 'Şifre * (en az 6 karakter)',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 16),

          // Şifre Tekrar
          CustomTextField(
            controller: _sifreTekrarController,
            hint: 'Şifre Tekrar *',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 32),

          // Kayıt Ol Butonu
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
                      'Kulüp Olarak Kayıt Ol',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
