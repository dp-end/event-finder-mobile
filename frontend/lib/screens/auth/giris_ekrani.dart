import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../widgets/custom_text_field.dart';

// 1. Sayfayı StatelessWidget'tan StatefulWidget'a çevirdik
class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  // 2. Kullanıcının yazdığı metinleri tutacak kontrolcüler
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // 3. Yükleniyor animasyonu için durum değişkeni
  bool _isLoading = false;

  // 4. Backend'e istek atan ana fonksiyon
  Future<void> _girisYap() async {
    // Eğer alanlar boşsa uyarı ver
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Yükleniyor animasyonunu başlat
    });

    try {
      // DİKKAT: .NET backendin localhost'ta çalışıyor. 
      // Android Emülatör için localhost adresi 10.0.2.2'dir.
      // Port numarasını (örn: 5000, 5001, 7155) backend terminalinde yazan porta göre GÜNCELLE!
      // 'api/Account/authenticate' kısmını da Swagger'daki adrese göre düzenle.
      final url = Uri.parse('http://10.0.2.2:9001/api/Account/authenticate');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      // Başarılı giriş (200 OK)
      if (response.statusCode == 200) {
        // İstersen burada dönen Token'ı cihaz hafızasına kaydedebilirsin
        // Şimdilik direkt anasayfaya yönlendiriyoruz
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Şifre yanlışsa veya hata varsa uyarı göster
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-posta veya şifre hatalı!')),
          );
        }
      }
    } catch (e) {
      // Konsola gerçek hatayı yazdırıyoruz:
      print("BAĞLANTI HATASI DETAYI: $e"); 
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sunucuya bağlanılamadı. Backend açık mı?')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // İşlem bitince yükleniyor animasyonunu durdur
      });
    }
  }

  @override
  void dispose() {
    // Hafıza sızıntısını önlemek için sayfadan çıkarken kontrolcüleri temizle
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              
              Image.asset(
                'assets/logo.png',
                height: 140,
              ),
              
              const SizedBox(height: 16),
              const Text(
                'Event Finder', 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                )
              ),
              const SizedBox(height: 50),
              
              // CustomTextField'larına oluşturduğumuz controller'ları bağladık
              CustomTextField(
                controller: _emailController, // BUNU EKLEDİK
                hint: 'E-posta Adresi', 
                icon: Icons.email_outlined
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController, // BUNU EKLEDİK
                hint: 'Şifre', 
                icon: Icons.lock_outline, 
                isPassword: true
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text(
                    'Şifremi Unuttum?', 
                    style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                // Butonun tıklandığı yer güncellendi
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8), 
                    foregroundColor: Colors.white, 
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  // _isLoading true ise butona tıklanamaz ve dönen bir çark görünür
                  onPressed: _isLoading ? null : _girisYap,
                  child: _isLoading 
                    ? const SizedBox(
                        height: 24, 
                        width: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text(
                        'Giriş Yap', 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
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
                      child: Text('VEYA', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
                    ),
                    Expanded(child: Divider())
                  ]
                ),
              ),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/signup-select'),
                  child: const Text(
                    'Kayıt Ol', 
                    style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}