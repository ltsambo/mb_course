import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
        labelText: label,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: const Color(0xFFF0F4F8), // Light grey fill
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        ),
        validator: validator ?? (value) => value!.isEmpty ? "Please enter $label" : null,
        onSaved: onSaved,
      ),
    );
  }
}

