import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller; // 1. EKLEME: Kontrolcü değişkenini tanımladık

  const CustomTextField({
    super.key, 
    required this.hint, 
    required this.icon, 
    this.isPassword = false,
    this.controller, // 2. EKLEME: Dışarıdan bu parametreyi kabul etmesini sağladık
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller, // 3. EKLEME (EN ÖNEMLİSİ): Gelen kontrolcüyü gerçek TextField'a bağladık
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}